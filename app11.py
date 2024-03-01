import streamlit as st
import requests 


#https://api.github.com
#https://the-one-api.dev
#https://favqs.com/api/qotd


def getRequest():

    if 'req' not in st.session_state:
        st.session_state.disabled = False

    req = st.text_input("Введите запрос для проверки", key='req', disabled=st.session_state.disabled)   
    button_a = st.button('Проверить запрос', key='but_a')

    response = requests.get(req)


    if response.status_code == 200:
        st.session_state.disabled = True 
        
    else:
        st.session_state.disabled = False
        
    st.write_stream(response)
    
getRequest() 