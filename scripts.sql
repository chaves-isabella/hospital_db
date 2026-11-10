CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE IF NOT EXISTS pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome_paciente VARCHAR(250) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone_paciente VARCHAR(20) NOT NULL,
    convenio VARCHAR(30) NOT NULL CHECK (convenio IN ('Unimed', 'Amil', 'Bradesco Saúde', 'Particular', 'SulAmérica', 'Unimed Pleno'))
);

CREATE TABLE IF NOT EXISTS medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome_medico VARCHAR(250) NOT NULL,
    crm VARCHAR(12) NOT NULL UNIQUE,
    especialidade VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS quartos (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numero_quarto INT NOT NULL UNIQUE,
    andar INT NOT NULL,
    tipo_quarto VARCHAR(50) NOT NULL CHECK (tipo_quarto IN ('Enfermaria', 'UTI', 'Apartamento', 'Suíte VIP')),
    status_quarto VARCHAR(20) NOT NULL CHECK (status_quarto IN ('Livre', 'Ocupado'))
);

CREATE TABLE IF NOT EXISTS internacoes (
    id_internacao INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_quarto INT NOT NULL,
    data_entrada DATE NOT NULL,
    data_saida DATE,
    valor_diaria DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_id_paciente FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_id_quarto FOREIGN KEY (id_quarto) REFERENCES quartos(id_quarto) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_consulta DATETIME NOT NULL,
    valor_consulta DECIMAL(10,2) NOT NULL,
    status_consulta VARCHAR(20) NOT NULL CHECK (status_consulta IN ('Realizada', 'Pendente')),
    CONSTRAINT fk_id_paciente_consulta FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_id_medico FOREIGN KEY (id_medico) REFERENCES medicos(id_medico) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS prescricoes (
    id_prescricao INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    medicamento VARCHAR(100) NOT NULL,
    dosagem VARCHAR(200) NOT NULL,
    quantidade INT NOT NULL,
    CONSTRAINT fk_id_consulta FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta) ON DELETE CASCADE ON UPDATE CASCADE
);