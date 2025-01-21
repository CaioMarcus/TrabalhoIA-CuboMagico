% Transpor uma matriz (lista de listas)
transpose([], []).
transpose([[]|_], []) :- !. % Caso base: todas as listas internas estão vazias
transpose(Matriz, [Linha|Transposta]) :-
    maplist(nth0(0), Matriz, Linha),        % Obter a primeira coluna da matriz
    maplist(remover_primeiro, Matriz, Resto), % Remover a primeira coluna de cada linha
    transpose(Resto, Transposta).          % Transpor o restante da matriz

% Remover o primeiro elemento de uma lista
remover_primeiro([_|Resto], Resto).

% Rotacionar uma face no sentido horário
rotacionar_face_horario(Face, NovaFace) :-
    transpose(Face, Transposta), % Transpor a matriz
    maplist(reverse, Transposta, NovaFace). % Reverter cada linha da transposta

% Rotacionar uma face no sentido anti-horário
rotacionar_face_anti_horario(Face, NovaFace) :-
    maplist(reverse, Face, FaceReversa), % Reverter cada linha
    transpose(FaceReversa, NovaFace). % Transpor a matriz resultante

% Obter a linha superior de uma face
linha_superior(Matriz, Linha) :-
    nth0(0, Matriz, Linha).

linha_inferior(Matriz, N, Linha) :-
    nth0(N, Matriz, Linha).

% Substituir a linha superior de uma matriz
substituir_linha_superior([_|Resto], NovaLinha, [NovaLinha|Resto]).

substituir_linha_inferior(Matriz, NovaLinha, NovaMatriz) :-
    append(Corpo, [_], Matriz),
    append(Corpo, [NovaLinha], NovaMatriz).

reverse_sentido(horario, anti_horario).
reverse_sentido(anti_horario, horario).

% Exemplo de rotação da face de cima no sentido horário
rotacionar_face(frente, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    atualizar_faces_adjacentes(Sentido, N1, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo),
    NovoCubo = cubo(NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo).

rotacionar_face(tras, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    
    rotacionar_face_horario(Direita, DireitaRotacionada),
    rotacionar_face_horario(DireitaRotacionada, DireitaRotacionada180),
    
    rotacionar_face_horario(Esquerda, EsquerdaRotacionada),
    rotacionar_face_horario(EsquerdaRotacionada, EsquerdaRotacionada180),
    
    rotacionar_face_horario(Frente, FrenteRotacionada),
    rotacionar_face_horario(FrenteRotacionada, FrenteRotacionada180),
    
    atualizar_faces_adjacentes(Sentido, N1, Baixo, Tras, DireitaRotacionada180, FrenteRotacionada180, EsquerdaRotacionada180, Cima, NovoBaixo, NovoTras, NovoDireita, NovoFrente, NovoEsquerda, NovoCima),
    
	rotacionar_face_anti_horario(NovoDireita, NovoDireitaRotacionada),
    rotacionar_face_anti_horario(NovoDireitaRotacionada, NovoDireitaRotacionada180),
    
    rotacionar_face_anti_horario(NovoEsquerda, NovoEsquerdaRotacionada),
    rotacionar_face_anti_horario(NovoEsquerdaRotacionada, NovoEsquerdaRotacionada180),
    
    rotacionar_face_anti_horario(NovoFrente, NovoFrenteRotacionada),
    rotacionar_face_anti_horario(NovoFrenteRotacionada, NovoFrenteRotacionada180),
    
    NovoCubo = cubo(NovoCima, NovoFrenteRotacionada180, NovoDireitaRotacionada180, NovoTras, NovoEsquerdaRotacionada180, NovoBaixo).


rotacionar_face(cima, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    rotacionar_face_anti_horario(Direita, DireitaRotacionada),
    rotacionar_face_horario(Esquerda, EsquerdaRotacionada),
    atualizar_faces_adjacentes(Sentido, N1, Tras, Cima, DireitaRotacionada, Baixo, EsquerdaRotacionada, Frente, NovoTras, NovoCima, NovoDireita, NovoBaixo, NovoEsquerda, NovoFrente),
    rotacionar_face_horario(NovoDireita, NovoDireitaRotacionada),
    rotacionar_face_anti_horario(NovoEsquerda, NovoEsquerdaRotacionada),        
    NovoCubo = cubo(NovoCima, NovoFrente, NovoDireitaRotacionada, NovoTras, NovoEsquerdaRotacionada, NovoBaixo).

rotacionar_face(baixo, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    rotacionar_face_horario(Direita, DireitaRotacionada),
    rotacionar_face_anti_horario(Esquerda, EsquerdaRotacionada),
    reverse_sentido(Sentido, SentidoCorrigido),
    atualizar_faces_adjacentes(SentidoCorrigido, N1, Frente, Baixo, DireitaRotacionada, Cima, EsquerdaRotacionada, Tras, NovoFrente, NovoBaixo, NovoDireita, NovoCima, NovoEsquerda, NovoTras),
    rotacionar_face_anti_horario(NovoDireita, NovoDireitaRotacionada),
    rotacionar_face_horario(NovoEsquerda, NovoEsquerdaRotacionada),        
    NovoCubo = cubo(NovoCima, NovoFrente, NovoDireitaRotacionada, NovoTras, NovoEsquerdaRotacionada, NovoBaixo).

rotacionar_face(esquerda, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    rotacionar_face_horario(Baixo, BaixoRotacionado),
    rotacionar_face_anti_horario(Cima, CimaRotacionado),
    
    rotacionar_face_anti_horario(Tras, TrasRotacionada),
    rotacionar_face_anti_horario(TrasRotacionada, TrasRotacionada180),
    
    rotacionar_face_anti_horario(Direita, DireitaRotacionada),
    rotacionar_face_anti_horario(DireitaRotacionada, DireitaRotacionada180),
    
    atualizar_faces_adjacentes(Sentido, N1, CimaRotacionado, Esquerda, Frente, DireitaRotacionada180, TrasRotacionada180, BaixoRotacionado, NovoCima, NovoEsquerda, NovoFrente, NovoDireita, NovoTras, NovoBaixo),
        
    rotacionar_face_horario(NovoCima, NovoCimaRotacionado),
    rotacionar_face_anti_horario(NovoBaixo, NovoBaixoRotacionado),        
    
    rotacionar_face_horario(NovoTras, NovoTrasRotacionada),
    rotacionar_face_horario(NovoTrasRotacionada, NovoTrasRotacionada180),
    
    rotacionar_face_horario(NovoDireita, NovoDireitaRotacionada),
    rotacionar_face_horario(NovoDireitaRotacionada, NovoDireitaRotacionada180),
    
    NovoCubo = cubo(NovoCimaRotacionado, NovoFrente, NovoDireitaRotacionada180, NovoTrasRotacionada180, NovoEsquerda, NovoBaixoRotacionado).

rotacionar_face(direita, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    rotacionar_face_anti_horario(Baixo, BaixoRotacionado),
    rotacionar_face_horario(Cima, CimaRotacionado),
    
    rotacionar_face_horario(Tras, TrasRotacionada),   
    rotacionar_face_horario(TrasRotacionada, TrasRotacionada180),   
    
    rotacionar_face_anti_horario(Esquerda, EsquerdaRotacionada),
    rotacionar_face_anti_horario(EsquerdaRotacionada, EsquerdaRotacionada180),
    
    atualizar_faces_adjacentes(Sentido, N1, CimaRotacionado, Direita, TrasRotacionada180, EsquerdaRotacionada180, Frente, BaixoRotacionado, NovoCima, NovoDireita, NovoTras, NovoEsquerda, NovoFrente, NovoBaixo),
        
    rotacionar_face_anti_horario(NovoCima, NovoCimaRotacionado),
    rotacionar_face_horario(NovoBaixo, NovoBaixoRotacionado),        
    
    rotacionar_face_anti_horario(NovoTras, NovoTrasRotacionada),
    rotacionar_face_anti_horario(NovoTrasRotacionada, NovoTrasRotacionada180),
    
    rotacionar_face_horario(NovoEsquerda, NovoEsquerdaRotacionada),
    rotacionar_face_horario(NovoEsquerdaRotacionada, NovoEsquerdaRotacionada180),
    
    NovoCubo = cubo(NovoCimaRotacionado, NovoFrente, NovoDireita, NovoTrasRotacionada180, NovoEsquerdaRotacionada180, NovoBaixoRotacionado).

% Atualizar as faces adjacentes ao rotacionar a face da frente
atualizar_faces_adjacentes(horario, N, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo) :-
    transpose(Direita, DireitaTransposta),
    transpose(Esquerda, EsquerdaTransposta),    
    
    linha_inferior(EsquerdaTransposta, N, LinhaInferiorEsquerdaTransposta),
    linha_inferior(Cima, N, LinhaInferiorCima),    
    linha_superior(DireitaTransposta, LinhaSuperiorDireitaTransposta),               
    linha_superior(Baixo, LinhaSuperiorBaixo),
        
    reverse(LinhaSuperiorDireitaTransposta, LinhaSuperiorDireitaTranspostaInvertida),
    reverse(LinhaInferiorEsquerdaTransposta, LinhaInferiorEsquerdaTranspostaInvertida),
    
    % Atualizar as bordas no sentido horário
    substituir_linha_inferior(Cima, LinhaInferiorEsquerdaTranspostaInvertida, NovoCima),    
    substituir_linha_superior(DireitaTransposta, LinhaInferiorCima, NovoDireitaT),
    substituir_linha_superior(Baixo, LinhaSuperiorDireitaTranspostaInvertida, NovoBaixo),
    substituir_linha_inferior(EsquerdaTransposta, LinhaSuperiorBaixo, NovoEsquerdaT),

    NovoTras = Tras,                                                                                                                                                                                                                                                                                                        
    rotacionar_face_horario(Frente, NovoFrente),
    transpose(NovoEsquerdaT, NovoEsquerda),
	transpose(NovoDireitaT, NovoDireita).

% Atualizar as faces adjacentes ao rotacionar a face da frente
atualizar_faces_adjacentes(anti_horario, N, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo) :-
    transpose(Direita, DireitaTransposta),
    transpose(Esquerda, EsquerdaTransposta),    
    
    linha_inferior(EsquerdaTransposta, N, LinhaInferiorEsquerdaTransposta),
    linha_inferior(Cima, N, LinhaInferiorCima),    
    linha_superior(DireitaTransposta, LinhaSuperiorDireitaTransposta),               
    linha_superior(Baixo, LinhaSuperiorBaixo),
        
    reverse(LinhaInferiorCima, LinhaInferiorCimaInvertida),
    reverse(LinhaSuperiorBaixo, LinhaSuperiorBaixoInvertida),
    
    % Atualizar as bordas no sentido horário
    substituir_linha_inferior(Cima, LinhaSuperiorDireitaTransposta, NovoCima),    
    substituir_linha_superior(DireitaTransposta, LinhaSuperiorBaixoInvertida, NovoDireitaT),
    substituir_linha_superior(Baixo, LinhaInferiorEsquerdaTransposta, NovoBaixo),
    substituir_linha_inferior(EsquerdaTransposta, LinhaInferiorCimaInvertida, NovoEsquerdaT),

    NovoTras = Tras,                                                                                                                                                                                                                                                                                                        
    rotacionar_face_anti_horario(Frente, NovoFrente),
    transpose(NovoEsquerdaT, NovoEsquerda),
	transpose(NovoDireitaT, NovoDireita).
