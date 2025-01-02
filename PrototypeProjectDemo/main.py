import streamlit as st

from helpers.authentication import login
from helpers.processor import process_files
from helpers.genai import generate_answer, load_grounding_data, initialize_openai, handle_submit, stream_answer

# Streamlit UI
def main():
    st.set_page_config()
    st.title("Doc. GenAI")

    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False

    if not st.session_state.authenticated:
        login()
    else:
        # Session state to maintain chat history and input state
        if "chat_history" not in st.session_state:
            st.session_state.chat_history = []
        if "query_input" not in st.session_state:
            st.session_state.query_input = ""

        # Load grounding data
        grounding_data = load_grounding_data()

        # Display chat history above input fields
        st.subheader("Chat History")
        chat_container = st.empty()
        with chat_container.container():
            for i, message in enumerate(st.session_state.chat_history):
                st.markdown(
                    f"""
                    <div style='display: flex; justify-content: flex-end;'>
                        <div style='padding:10px; border-radius:5px; background: rgba(203,195,230,0.2); max-width: 70%; margin: 5px 0;'>
                            {message['question']}
                        </div>
                    </div>
                    """,
                    unsafe_allow_html=True
                )
                if message['answer']:
                    st.markdown(message['answer'])
                else:
                    answer_placeholder = st.empty()

        # Sidebar for file upload
        st.sidebar.image('logo.png', width=150)
        st.sidebar.header("Upload Files")
        uploaded_files = st.sidebar.file_uploader("Note: Transient storage only", type=["pdf", "docx", "doc", "pptx", "ppt", "txt", "csv", "xlsx"], accept_multiple_files=True)

        # Placeholder for the input area
        input_area_placeholder = st.empty()

        # Main area for query input
        with input_area_placeholder.container():
            with st.form(key='file_question_form'):
                search_query = st.text_area("Enter your question", key="query_input")
                submit_button = st.form_submit_button(label='Submit', help='Submit the question', on_click=handle_submit)

        st.write("Generative AI is under development and can produce incorrect responses. Use with caution.")

        if submit_button and st.session_state.search_query:
            with st.spinner("Processing..."):
                initialize_openai()
                st.session_state.chat_history.append({"question": st.session_state.search_query, "answer": ""})
                chat_container.empty()
                with chat_container.container():
                    for i, message in enumerate(st.session_state.chat_history):
                        st.markdown(
                            f"""
                            <div style='display: flex; justify-content: flex-end;'>
                                <div style='padding:10px; border-radius:5px; background: rgba(203,195,230,0.2); max-width: 70%; margin: 5px 0;'>
                                    {message['question']}
                                </div>
                            </div>
                            """,
                            unsafe_allow_html=True
                        )
                        if message['answer']:
                            st.markdown(message['answer'])
                        else:
                            answer_placeholder = st.empty()

                if uploaded_files:
                    answer = process_files(uploaded_files, st.session_state.search_query, grounding_data)
                else:
                    context = grounding_data
                    answer = generate_answer(context, st.session_state.search_query)

                stream_answer(answer_placeholder, answer)

                st.session_state.chat_history[-1]['answer'] = answer
                st.session_state.search_query = ""
        st.markdown(footer_html, unsafe_allow_html=True)

footer_html = """
<div style='text-align: center;'>
  <p>
    Author: Aditya Jagdale <br>
    Developed with ❤️ using Streamlit
   </p>
</div>
"""
        
if __name__ == "__main__":
    main()