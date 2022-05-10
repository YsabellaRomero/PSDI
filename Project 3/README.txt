Pontos 3 e 4 do guião:

O código RTL foi bem sucedido após uma série de testes. Foi criado um ciclo no código do testbench, nas linhas 118 à 125, de modo a garantir sempre o funcionamento correto à medida que se avançou no projeto. Este ciclo imprime sempre OK para os resultados corretos.
Também foi verificada a funcionalidade dos sinais de controlo (reset, start e stop) de acordo com as especificações no guião, e para tal, foi criado um ficheiro .vcd e observado no programa gtkwave. Adicionamos um screenshot (ponto3&4_funcional) neste zip daquilo que foi visualizado através do ficheiro em questão para um dos testes. O teste consistiu em atribuir o valor 123456 (0001E240 em hexadecimal) para xin e o resultado obtido foi 351 (015F em hexadecimal), pois a raiz quadrada de 123456 é 351 (arredondado). Dito isto, pudemos dar como bem sucedidas estas duas primeiras etapas.

Ponto 5.1 do guião:

Tal como pedido, foi criado um parâmetro (NBITSIN) no qual o utilizador definirá o seu valor ao instanciar o módulo psdsqrt. O valor por default é 32. Mais uma vez foi confirmado o funcionamento através do ciclo (no ficheiro do testebench) mencionado no ponto anterior. Uma vez termos um tamanho de NBITS para xin, no ficheiro psdsqrt.v, no if da linha 51, garante-se que este registro tem efetivamente entre 4 a 64 bits.

Ponto 5.2 do guião:

Primeiramente foi criado um parâmetro chamado k que tem como valor por default, 20. O utilizador terá chance de definir o valor exatamente da mesma maneira que o NBITS.

Relativamente ao resto do que foi feito neste ponto, deixamos comentado pois não permitiam chegar a um resultado final correto. No entanto, deixamos a explicação dos dois troços de código comentados relativos a este ponto para o caso do professor querer experimentar e possivelmente entender o nosso raciocínio:


LINHAS 53 à 57:
Verificação se o valor definido pelo utilizador para k é ou não ímpar. Caso assim seja, então tornámo-lo par.


LINHAS 100 à 115:

Antes de mais, criamos uma variável auxiliar aux (um registro com a mesma dimensão que o sqrt) para podermos tratar do arredondamento e só após o mesmo estar finalizado, igualar o sqrt a esse resultado final.
Assim sendo, aux foi igualado ao resultado obtido no flip flop com o stop (como enable). 

Na linha 104, if(aux[((NBITSIN+k)/2)-1:((NBITSIN)/2)-1] > 'h1000) --> estamos a comparar os últimos k/2 bits do resultado da raiz quadrada com o que seria correspondente ao 0.5 em binário. Foi decidido 'h1000 porque 0.1000b é igual a 0.5 em decimal e pela forma como abordamos o problema, o circuito não reconhece que é um valor decimal mas nós estamos a trata-lo como se fosse. Este if em específico tinha como foco verificar se o valor na parte decimal era maior que 0.5 para arredondar uma unidade.
No if seguinte (= 0.5), encarregamo-nos de verificar se ao incrementarmos uma unidade, se o resultado dá ou não par. Caso fosse, é aumentar uma unidade, senão é manter.
A lógica é intuitiva para o último if.


De qualquer dos modos para este ponto no guião, foi tudo deixado comentado exceto as dimensões das variáveis conforme o NBITSIN e k, pois não seria isso o que fora afetar o comportamento desejado do circuito.


NOTA: Também foram ajustadas as dimensões no testbench através dos parâmetros NBITSIN e k.

