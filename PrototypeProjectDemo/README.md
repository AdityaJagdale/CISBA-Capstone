# Doc. GenAI

## Your AI-Powered Document Assistant

**What is Doc.GenAI?**

Doc.GenAI is a powerful Streamlit application designed to assist you in understanding and extracting information from various document formats. It leverages the capabilities of OpenAI's language models to provide insightful answers to your queries, directly from the uploaded documents.

This project was developed as a part of a Capstone class, demonstrating the potential of AI in document analysis and understanding.


---

**How it Works:**


1. **Upload Documents:**
   * You can upload various document formats, including PDF, DOCX, PPTX, TXT, CSV, and XLSX.
2. **Ask Your Questions:**
   * Enter your query in the text box provided.
3. **Get Instant Answers:**
   * Doc.GenAI processes your documents and provides relevant answers to your questions.

**To use Doc.GenAI:**

**Note to Dr. Babb:** I have deployed this app on streamlit community and invited you with your WT email to access this website: <https://docgenai-capstone.streamlit.app/>

Local users:


1. **Clone the Repository:**
   * Clone this repository to your local machine.
2. **Set Up Environment:**
   * Create a virtual environment and install the required dependencies:

     Bash

     ```
     python -m venv venv
     source venv/bin/activate
     pip install -r requirements.txt  
     ```

     Use code [with caution.](/faq#coding)
3. **Obtain an OpenAI API Key:**
   * Sign up for an OpenAI account and create an API key.
4. **Add API Key to Streamlit Secrets:**
   * Follow Streamlit's instructions to add your OpenAI API key as a secret. Refer to Streamlit's documentation for detailed instructions. (Can simply be adding a .streamlit folder and adding a secrets.toml file in it with your secret)
5. **Run the App:**
   * Navigate to the project directory in your terminal.
   * Run the following command:

     Bash

     ```
     streamlit run main.py
     ```

     Use code [with caution.](/faq#coding)

**Important Note:**

Ensure you have a strong internet connection and a stable OpenAI API key to ensure optimal performance.