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

% Exemplo de rotação da face de cima no sentido horário
rotacionar_face(Face, Sentido, N, cubo(Cima, Frente, Direita, Tras, Esquerda, Baixo), NovoCubo) :-
    N1 is N - 1,
    atualizar_faces_adjacentes(Face, Sentido, N1, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo),
    NovoCubo = cubo(NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo).

% Atualizar as faces adjacentes ao rotacionar a face de cima
atualizar_faces_adjacentes(cima, horario, _, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo) :-
    linha_superior(Frente, LinhaFrente),
    linha_superior(Esquerda, LinhaEsquerda),
    linha_superior(Tras, LinhaTras),
    linha_superior(Direita, LinhaDireita),
    
    % Atualizar as bordas no sentido horário
    NovaLinhaFrente = LinhaDireita,
    NovaLinhaDireita = LinhaTras,
    NovaLinhaTras = LinhaEsquerda,
    NovaLinhaEsquerda = LinhaFrente,
    
    NovoBaixo = Baixo,
    rotacionar_face_horario(Cima, NovoCima),    
    substituir_linha_superior(Frente, NovaLinhaFrente, NovoFrente),
    substituir_linha_superior(Direita, NovaLinhaDireita, NovoDireita),
    substituir_linha_superior(Tras, NovaLinhaTras, NovoTras),
    substituir_linha_superior(Esquerda, NovaLinhaEsquerda, NovoEsquerda).

% Atualizar as faces adjacentes ao rotacionar a face de cima
atualizar_faces_adjacentes(cima, anti_horario, _, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo) :-
    linha_superior(Frente, LinhaFrente),
    linha_superior(Esquerda, LinhaEsquerda),
    linha_superior(Tras, LinhaTras),
    linha_superior(Direita, LinhaDireita),
    
    % Atualizar as bordas no sentido anti-horário
    NovaLinhaFrente = LinhaEsquerda,
    NovaLinhaDireita = LinhaFrente,
    NovaLinhaTras = LinhaDireita,
    NovaLinhaEsquerda = LinhaTras,
    
    NovoBaixo = Baixo,
    rotacionar_face_anti_horario(Cima, NovoCima),    
    substituir_linha_superior(Frente, NovaLinhaFrente, NovoFrente),
    substituir_linha_superior(Direita, NovaLinhaDireita, NovoDireita),
    substituir_linha_superior(Tras, NovaLinhaTras, NovoTras),
    substituir_linha_superior(Esquerda, NovaLinhaEsquerda, NovoEsquerda).

% Atualizar as faces adjacentes ao rotacionar a face da frente
atualizar_faces_adjacentes(frente, horario, N, Cima, Frente, Direita, Tras, Esquerda, Baixo, NovoCima, NovoFrente, NovoDireita, NovoTras, NovoEsquerda, NovoBaixo) :-
    transpose(Direita, DireitaTransposta),
    transpose(Esquerda, EsquerdaTransposta),    
    
    linha_inferior(Esquerda, N, LinhaInferiorEsquerda),    
    linha_inferior(Cima, N, LinhaInferiorCima),    
    linha_superior(DireitaTransposta, LinhaSuperiorDireita),
    linha_superior(Baixo, LinhaSuperiorBaixo),
    
    reverse(LinhaSuperiorDireita, LinhaSuperiorDireitaInvertida),
    
    % Atualizar as bordas no sentido horário
    substituir_linha_inferior(Cima, LinhaInferiorEsquerda, NovoCima),    
    substituir_linha_inferior(Direita, LinhaInferiorCima, NovoDireita),
    substituir_linha_superior(Baixo, LinhaSuperiorDireitaInvertida, NovoBaixo),
    substituir_linha_inferior(EsquerdaTransposta, LinhaSuperiorBaixo, NovoEsquerdaT),

    NovoTras = Tras,                                                                                                                                                                                                                                                                                                        
    rotacionar_face_horario(Frente, NovoFrente),
    transpose(NovoEsquerdaT, NovoEsquerda).
