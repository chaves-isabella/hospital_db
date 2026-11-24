USE hospital_db;

-- 1. Relatório da farmácia
SELECT p.nome_paciente, m.nome_medico, c.data_consulta, pr.medicamento, pr.quantidade
FROM prescricoes pr
JOIN consultas c ON pr.id_consulta = c.id_consulta
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

-- 2. Histórico de internações (auditoria)
SELECT p.nome_paciente, q.numero_quarto, q.andar, i.data_entrada, i.valor_diaria
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto;

-- 3. Listagem para a recepção (todos os pacientes, mesmo sem consulta)
SELECT p.nome_paciente, p.convenio, m.nome_medico, m.especialidade
FROM pacientes p
LEFT JOIN consultas c ON c.id_paciente = p.id_paciente
LEFT JOIN medicos m ON c.id_medico = m.id_medico;

-- 4. Prescrições para a coordenação médica
SELECT m.nome_medico, m.especialidade, p.nome_paciente, pr.medicamento
FROM prescricoes pr
JOIN consultas c ON pr.id_consulta = c.id_consulta
JOIN medicos m ON c.id_medico = m.id_medico
JOIN pacientes p ON c.id_paciente = p.id_paciente;

-- 5. Pacientes internados que também tiveram consultas (sem duplicidade)
SELECT DISTINCT p.nome_paciente, q.numero_quarto, m.nome_medico, c.data_consulta
FROM pacientes p
JOIN internacoes i ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
JOIN consultas c ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

-- 6. Consultas mais recentes primeiro
SELECT p.nome_paciente, m.nome_medico, c.data_consulta
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
ORDER BY c.data_consulta DESC;

-- 7. Diárias do menor para o maior valor
SELECT p.nome_paciente, q.numero_quarto, i.valor_diaria
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
ORDER BY i.valor_diaria ASC;

-- 8. Valor médio das consultas
SELECT AVG(valor_consulta) AS valor_medio_consultas
FROM consultas;

-- 9. Total arrecadado com consultas
SELECT SUM(valor_consulta) AS total_arrecadado
FROM consultas;

-- 10. Consultas de pacientes da família "Silva"
SELECT p.nome_paciente, m.nome_medico, c.data_consulta
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
WHERE p.nome_paciente LIKE '%Silva%';

-- 11. Consultas com médicos ligados à Cardiologia
SELECT p.nome_paciente, m.nome_medico, m.especialidade
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cardio%';

-- 12. Internações do 1º semestre de 2026
SELECT p.nome_paciente, q.numero_quarto, i.data_entrada
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE i.data_entrada BETWEEN '2026-01-01' AND '2026-06-30';

-- 13. Total gasto em consultas por pacientes Unimed (qualquer variação)
SELECT p.nome_paciente, p.convenio, SUM(c.valor_consulta) AS total_gasto
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.convenio LIKE '%Unimed%'
GROUP BY p.id_paciente, p.nome_paciente, p.convenio
ORDER BY total_gasto DESC;

-- 14. Custo total das diárias por andar (pacientes "Oliveira")
-- Obs.: considera o valor da diária registrado em cada internação.
-- Para multiplicar pelos dias, use:
--   SUM(i.valor_diaria * DATEDIFF(i.data_saida, i.data_entrada))
SELECT q.andar, SUM(i.valor_diaria) AS custo_total_diarias
FROM internacoes i
JOIN pacientes p ON i.id_paciente = p.id_paciente
JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE p.nome_paciente LIKE '%Oliveira%'
GROUP BY q.andar
ORDER BY q.andar ASC;

-- 15. Faturamento por especialidades cirúrgicas
SELECT m.especialidade, SUM(c.valor_consulta) AS total_arrecadado
FROM consultas c
JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cirurgia%'
GROUP BY m.especialidade
ORDER BY total_arrecadado DESC;
