Pontos 3 e 4 do guião:

O código RTL foi bem sucedido após uma série de testes. Foi criado um ciclo no código do testbench, nas linhas GARANTIR ISTO OK YSABELLOCAS? 120 à 127, de modo a garantir sempre o funcionamento correto à medida que se avançou no projeto. Este ciclo imprime sempre OK para os resultados corretos.
Também foi verificada a funcionalidade dos sinais de controlo (reset, start e stop) de acordo com as especificações no guião, e para tal, foi criado um ficheiro .vcd e observado no programa gtkwave. Adicionamos um screenshot neste zip daquilo que foi visualizado através do ficheiro em questão para um dos testes. O teste consistiu em atribuir o valor 123456 (0001E240 em hexadecimal) para xin e o resultado obtido foi 351 (015F em hexadecimal), pois a raiz quadrada de 123456 é 351 (arredondado). Dito isto, pudemos dar como bem sucedidas estas duas primeiras etapas.

Ponto 5.1 do guião:

Tal como pedido, foi criado um parâmetro (NBITS) no qual o utilizador definirá o seu valor ao instanciar o módulo psdsqrt. O valor por default é 32. Mais uma vez foi confirmado o funcionamento através do ciclo (no ficheiro do testebench) mencionado no ponto anterior. Uma vez termos um tamanho de NBITS para xin, no ficheiro psdsqrt.v, no if da GARANTIR ISTO OK YSABELLOCAS? linha 49, garante-se que este registro tem efetivamente entre 4 a 64 bits.

Ponto 5.2 do guião:

Primeiramente foi criado um parâmetro chamado k que tem como valor por default, 20. O utilizador terá chance de definir o valor exatamente da mesma maneira que o NBITS.
No ficheiro psdsqrt.v da linha GARANTIR ISTO OK YSABELLOCAS? 51 à 57, verificamos se o valor definido pelo utilizador para k é ou não ímpar. Caso assim seja, então tornámo-lo par.
