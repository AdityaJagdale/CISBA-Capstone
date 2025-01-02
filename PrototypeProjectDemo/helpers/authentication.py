import streamlit as st
import yaml
from argon2 import PasswordHasher

# Function to hash passwords using Argon2
def hash_password(password):
    ph = PasswordHasher()
    hashed_password = ph.hash(password)
    return hashed_password

# Function to load credentials from YAML file
def load_credentials():
    try:
        with open('credentials.yaml', 'r') as f:
            credentials = yaml.safe_load(f)
            for user, password in credentials['users'].items():
                credentials['users'][user] = hash_password(password)
            return credentials
    except Exception as e:
        st.error(f"Error loading credentials: {e}")
        return None

# Function to login
def login():
    credentials = load_credentials()
    ph = PasswordHasher()
    if not credentials:
        return

    username = st.text_input("Username")
    password = st.text_input("Password", type="password")

    if st.button("Login"):
        if username in credentials['users'] and ph.verify(credentials['users'][username], password):
            st.session_state.authenticated = True
            st.success("Logged in successfully!")

            st.rerun()
        else:
            st.error("Incorrect username or password")