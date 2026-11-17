import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from cryptography.fernet import Fernet
import os


# ============================================================
# 1. CONFIGURAÇÃO DO BANCO DE DADOS
# ============================================================

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "cofre_credenciais"
}


# ============================================================
# 2. ARQUIVO DA CHAVE DE CRIPTOGRAFIA
# ============================================================

PASTA_PROJETO = os.path.dirname(os.path.abspath(__file__))
ARQUIVO_CHAVE = os.path.join(PASTA_PROJETO, "chave.key")


def carregar_chave():
    """
    Cria uma chave na primeira execução.
    Depois utiliza sempre a mesma chave.
    """

    if not os.path.exists(ARQUIVO_CHAVE):
        chave = Fernet.generate_key()

        with open(ARQUIVO_CHAVE, "wb") as arquivo:
            arquivo.write(chave)

    else:
        with open(ARQUIVO_CHAVE, "rb") as arquivo:
            chave = arquivo.read()

    return Fernet(chave)


fernet = carregar_chave()


# ============================================================
# 3. CRIPTOGRAFIA
# ============================================================

def criptografar_senha(senha):
    """
    Recebe a senha normal e transforma em texto criptografado.
    """

    senha_bytes = senha.encode("utf-8")

    senha_criptografada = fernet.encrypt(senha_bytes)

    return senha_criptografada.decode("utf-8")


def descriptografar_senha(senha_criptografada):
    """
    Recebe o texto criptografado e recupera a senha original.
    """

    senha_bytes = senha_criptografada.encode("utf-8")

    senha_original = fernet.decrypt(senha_bytes)

    return senha_original.decode("utf-8")


# ============================================================
# 4. CONEXÃO COM O MYSQL
# ============================================================

def conectar_banco():
    return mysql.connector.connect(**DB_CONFIG)


# ============================================================
# 5. CADASTRAR
# ============================================================

def cadastrar():

    servico = entrada_servico.get().strip()
    usuario = entrada_usuario.get().strip()
    senha = entrada_senha.get()

    if not servico or not usuario or not senha:
        messagebox.showwarning(
            "Campos obrigatórios",
            "Preencha Serviço, Usuário e Senha."
        )
        return

    try:

        conexao = conectar_banco()
        cursor = conexao.cursor()

        # A senha é criptografada ANTES de ser enviada ao banco.
        senha_criptografada = criptografar_senha(senha)

        comando = """
            INSERT INTO credenciais (servico, usuario, senha)
            VALUES (%s, %s, %s)
        """

        cursor.execute(
            comando,
            (
                servico,
                usuario,
                senha_criptografada
            )
        )

        conexao.commit()

        cursor.close()
        conexao.close()

        limpar_campos()
        atualizar_lista()

        messagebox.showinfo(
            "Sucesso",
            "Credencial cadastrada com sucesso!"
        )

    except mysql.connector.Error as erro:

        messagebox.showerror(
            "Erro no banco de dados",
            f"Não foi possível cadastrar:\n{erro}"
        )


# ============================================================
# 6. LISTAR CREDENCIAIS
# ============================================================

def atualizar_lista():

    for item in tabela.get_children():
        tabela.delete(item)

    try:

        conexao = conectar_banco()
        cursor = conexao.cursor()

        cursor.execute("""
            SELECT id, servico, usuario
            FROM credenciais
            ORDER BY id
        """)

        registros = cursor.fetchall()

        for registro in registros:

            tabela.insert(
                "",
                "end",
                values=(
                    registro[0],
                    registro[1],
                    registro[2]
                )
            )

        cursor.close()
        conexao.close()

    except mysql.connector.Error as erro:

        messagebox.showerror(
            "Erro",
            f"Não foi possível carregar os dados:\n{erro}"
        )


# ============================================================
# 7. REVELAR SENHA
# ============================================================

def revelar_senha():

    selecionado = tabela.selection()

    if not selecionado:

        messagebox.showwarning(
            "Nenhum registro",
            "Selecione uma credencial primeiro."
        )

        return

    item = tabela.item(selecionado[0])

    id_credencial = item["values"][0]

    try:

        conexao = conectar_banco()
        cursor = conexao.cursor()

        cursor.execute(
            "SELECT senha FROM credenciais WHERE id = %s",
            (id_credencial,)
        )

        resultado = cursor.fetchone()

        cursor.close()
        conexao.close()

        if resultado:

            senha_criptografada = resultado[0]

            # Aqui acontece o processo inverso:
            # texto criptografado -> senha original.
            senha_original = descriptografar_senha(
                senha_criptografada
            )

            messagebox.showinfo(
                "Senha",
                f"Senha da credencial:\n\n{senha_original}"
            )

    except Exception as erro:

        messagebox.showerror(
            "Erro",
            f"Não foi possível revelar a senha:\n{erro}"
        )


# ============================================================
# 8. ALTERAR
# ============================================================

def alterar():

    selecionado = tabela.selection()

    if not selecionado:

        messagebox.showwarning(
            "Nenhum registro",
            "Selecione uma credencial para alterar."
        )

        return

    item = tabela.item(selecionado[0])

    id_credencial = item["values"][0]

    servico = entrada_servico.get().strip()
    usuario = entrada_usuario.get().strip()
    senha = entrada_senha.get()

    if not servico or not usuario or not senha:

        messagebox.showwarning(
            "Campos obrigatórios",
            "Preencha Serviço, Usuário e Senha."
        )

        return

    try:

        conexao = conectar_banco()
        cursor = conexao.cursor()

        # A nova senha também é criptografada
        # antes do UPDATE.
        senha_criptografada = criptografar_senha(senha)

        comando = """
            UPDATE credenciais
            SET servico = %s,
                usuario = %s,
                senha = %s
            WHERE id = %s
        """

        cursor.execute(
            comando,
            (
                servico,
                usuario,
                senha_criptografada,
                id_credencial
            )
        )

        conexao.commit()

        cursor.close()
        conexao.close()

        limpar_campos()
        atualizar_lista()

        messagebox.showinfo(
            "Sucesso",
            "Credencial alterada com sucesso!"
        )

    except mysql.connector.Error as erro:

        messagebox.showerror(
            "Erro",
            f"Não foi possível alterar:\n{erro}"
        )


# ============================================================
# 9. EXCLUIR
# ============================================================

def excluir():

    selecionado = tabela.selection()

    if not selecionado:

        messagebox.showwarning(
            "Nenhum registro",
            "Selecione uma credencial para excluir."
        )

        return

    item = tabela.item(selecionado[0])

    id_credencial = item["values"][0]

    confirmar = messagebox.askyesno(
        "Confirmar exclusão",
        "Tem certeza que deseja excluir esta credencial?"
    )

    if not confirmar:
        return

    try:

        conexao = conectar_banco()
        cursor = conexao.cursor()

        cursor.execute(
            "DELETE FROM credenciais WHERE id = %s",
            (id_credencial,)
        )

        conexao.commit()

        cursor.close()
        conexao.close()

        limpar_campos()
        atualizar_lista()

        messagebox.showinfo(
            "Sucesso",
            "Credencial excluída com sucesso!"
        )

    except mysql.connector.Error as erro:

        messagebox.showerror(
            "Erro",
            f"Não foi possível excluir:\n{erro}"
        )


# ============================================================
# 10. SELECIONAR REGISTRO
# ============================================================

def selecionar_registro(event=None):

    selecionado = tabela.selection()

    if not selecionado:
        return

    item = tabela.item(selecionado[0])

    entrada_servico.delete(0, tk.END)
    entrada_usuario.delete(0, tk.END)
    entrada_senha.delete(0, tk.END)

    entrada_servico.insert(
        0,
        item["values"][1]
    )

    entrada_usuario.insert(
        0,
        item["values"][2]
    )


# ============================================================
# 11. LIMPAR CAMPOS
# ============================================================

def limpar_campos():

    entrada_servico.delete(0, tk.END)
    entrada_usuario.delete(0, tk.END)
    entrada_senha.delete(0, tk.END)

    tabela.selection_remove(
        tabela.selection()
    )


# ============================================================
# 12. INTERFACE GRÁFICA
# ============================================================

janela = tk.Tk()

janela.title(
    "Cofre de Credenciais Pessoal"
)

janela.geometry(
    "750x550"
)

janela.resizable(
    False,
    False
)


# ---------- TÍTULO ----------

titulo = tk.Label(
    janela,
    text="🔐 Cofre de Credenciais Pessoal",
    font=("Arial", 20, "bold")
)

titulo.pack(
    pady=15
)


# ---------- FORMULÁRIO ----------

frame_formulario = tk.Frame(janela)

frame_formulario.pack(
    pady=5
)


tk.Label(
    frame_formulario,
    text="Serviço:"
).grid(
    row=0,
    column=0,
    padx=5,
    pady=5,
    sticky="e"
)


entrada_servico = tk.Entry(
    frame_formulario,
    width=40
)

entrada_servico.grid(
    row=0,
    column=1,
    padx=5,
    pady=5
)


tk.Label(
    frame_formulario,
    text="Usuário:"
).grid(
    row=1,
    column=0,
    padx=5,
    pady=5,
    sticky="e"
)


entrada_usuario = tk.Entry(
    frame_formulario,
    width=40
)

entrada_usuario.grid(
    row=1,
    column=1,
    padx=5,
    pady=5
)


tk.Label(
    frame_formulario,
    text="Senha:"
).grid(
    row=2,
    column=0,
    padx=5,
    pady=5,
    sticky="e"
)


entrada_senha = tk.Entry(
    frame_formulario,
    width=40,
    show="*"
)

entrada_senha.grid(
    row=2,
    column=1,
    padx=5,
    pady=5
)


# ---------- BOTÕES ----------

frame_botoes = tk.Frame(janela)

frame_botoes.pack(
    pady=10
)


tk.Button(
    frame_botoes,
    text="Cadastrar",
    width=14,
    command=cadastrar
).grid(
    row=0,
    column=0,
    padx=5
)


tk.Button(
    frame_botoes,
    text="Alterar",
    width=14,
    command=alterar
).grid(
    row=0,
    column=1,
    padx=5
)


tk.Button(
    frame_botoes,
    text="Excluir",
    width=14,
    command=excluir
).grid(
    row=0,
    column=2,
    padx=5
)


tk.Button(
    frame_botoes,
    text="Limpar",
    width=14,
    command=limpar_campos
).grid(
    row=0,
    column=3,
    padx=5
)


# ---------- TABELA ----------

frame_tabela = tk.Frame(janela)

frame_tabela.pack(
    pady=15
)


colunas = (
    "id",
    "servico",
    "usuario"
)


tabela = ttk.Treeview(
    frame_tabela,
    columns=colunas,
    displaycolumns=(
        "servico",
        "usuario"
    ),
    show="headings",
    height=10
)


tabela.heading(
    "id",
    text="ID"
)

tabela.heading(
    "servico",
    text="Serviço"
)

tabela.heading(
    "usuario",
    text="Usuário"
)


# ID fica escondido na interface.
tabela.column(
    "id",
    width=0,
    stretch=False
)

tabela.column(
    "servico",
    width=300
)

tabela.column(
    "usuario",
    width=300
)


tabela.pack()


tabela.bind(
    "<<TreeviewSelect>>",
    selecionar_registro
)


# ---------- REVELAR SENHA ----------

tk.Button(
    janela,
    text="👁 Revelar Senha",
    width=20,
    command=revelar_senha
).pack(
    pady=10
)


# ============================================================
# 13. INICIAR PROGRAMA
# ============================================================

atualizar_lista()

janela.mainloop()