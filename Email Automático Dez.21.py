import win32com.client as win32
import pandas as pd


outlook = win32.Dispatch('outlook.application')

df = pd.read_excel("G:\\Drives compartilhados\\Gente e Gestão FVT\\Lucas\\2022\\03. Fechamentos\\05. PEES\\Dez.21\\Envio Dez.21.xlsx")

for i in range(0, len(df)):

    email_franquia = df['Email'].iloc[i]
    anexo = df['Caminho'].iloc[i]
    franchise = df['Franquia'].iloc[i]


    email = outlook.CreateItem(0)
    email.To = email_franquia
    email.Subject = f"PEES Dez.21 - {franchise}"
    email.HTMLBody = f"""
    <p>Olá, franqueado(a)!</p>
    <p>Segue, em anexo, a apuração do PEES referente ao período de 01/12/2021 a 31/12/2021. Para a correta visualização e análise dos dados, orientamos baixar o arquivo e abrir no Excel, ou seguir o caminho Abrir com - Planilhas Google.</p>
    <p>Se ficou alguma dúvida, pode consultar o seu DO ou abrir um ticket no Yungas.</p>
    <p>Ah, e não deixe de conferir os nossos materiais de auxílio de cada indicador no <a href="https://sites.google.com/stone.com.br/jornaldoempreendedor/pes" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://sites.google.com/stone.com.br/jornaldoempreendedor/pes&amp;source=gmail&amp;ust=1642598104710000&amp;usg=AOvVaw0KykgmPBOJgVUwWoDwbM4f">Jornal do Empreendedor</a>.</p>
    &nbsp;
    &nbsp;
    <p>Atenciosamente,</p>
    <p>Stone Franquia</p>
    &nbsp;
    &nbsp;
    <img src="https://ci6.googleusercontent.com/proxy/wwW5Xkvxv90QU-43lfkGEoCBnYq5v6-QjwxUouZV9vlygS3CUwPICTuxigtJB7agCpGW_e7dWU25Z0IxsozycVzfUuVA_YDYopxJzSbu4JKmT5HbMHtw=s0-d-e1-ft#https://storage.googleapis.com/public-assets-stg/site/email/logo.png" style="margin-bottom:16px;width:32px;height:32px" class="CToWUd">
    <span style="font-family:Tahoma,sans-serif;display:block;font-size:16px;line-height:24px;color:#20252a;font-weight:bold;margin-bottom:2px">Giulia Menghini Souza</span>
    <span style="font-family:Tahoma,sans-serif;display:block;font-size:14px;line-height:22px;color:rgb(32,37,42);margin-bottom:16px">Planejamento e Gestão | Franquias</span>
    <a style="font-family:Tahoma,sans-serif;display:block;font-size:14px;line-height:22px;color:rgb(32,37,42);margin-bottom:2px" href="mailto:giulia.souza@stone.com.br" target="_blank">
    giulia.souza@stone.com.br
    </a>
    """

    email.Attachments.Add(str(anexo))
    email.Send()
    email = 0
    print(franchise)
