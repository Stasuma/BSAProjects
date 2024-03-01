import streamlit as st
import requests 

#Примеры
#https://api.github.com
#https://the-one-api.dev
#https://favqs.com/api/qotd

def getRequest():

    if 'but_a' not in st.session_state:
        st.session_state.disabled = False

    req = st.text_input("Введите запрос для проверки", key='input',)   
    button_a = st.button('Проверить запрос', key='but_a', disabled=st.session_state.disabled)

    response = requests.get(req)


    if response.status_code == 200:
        st.session_state.disabled = True 
        st.write_stream(response)
        
    if response.status_code != 200:
        st.session_state.disabled = False
        st.error('Введите запрос снова')
getRequest() 
