## Documentação - App de Oficina Mecânica

### Visão Geral

Este aplicativo em Flutter auxilia oficinas mecânicas na gestão de suas operações. Ele implementa as seguintes funcionalidades:

- **CRUD de Proprietários**: Cadastro e gerenciamento dos proprietários dos veículos.  

- **CRUD de Carros**: Cada proprietário pode ter vários carros, com operações de cadastro, atualização e remoção.  

- **CRUD de Checklists**: Para cada carro, é possível criar, atualizar e excluir checklists.  

- **Itens do Checklist**: Cada checklist possui diversos itens que podem ser marcados para indicar se precisam de reparo ou troca, além de permitir adicionar observações.  

### Tecnologias Utilizadas

- **Flutter** e **Dart**: Para o desenvolvimento do aplicativo.
- **[SQFlite](https://pub.dev/packages/sqflite)**: Banco de dados SQLite para armazenamento local.  
- **[Logger](https://pub.dev/packages/logger)**: Para log de ações e erros.  
- **[Infinite Scroll Pagination](https://pub.dev/packages/infinite_scroll_pagination)**: Paginação de listas como carros e checklists.  
- **[Flutter Slidable](https://pub.dev/packages/flutter_slidable)**: Ações deslizantes para exclusão/edição de itens.
- **[Signals Flutter](https://dartsignals.dev/)**: Para gerenciamento de eventos e atualização de interfaces.

### Estrutura do Projeto

A estrutura do projeto está organizada da seguinte forma:

- **lib/database**: Contém a implementação do acesso ao banco de dados.  
- **lib/models**: Define os modelos de dados, como `Carro`, `Checklist`, `ChecklistItem`, etc.  
- **lib/presentation/pages**: Telas do aplicativo, como `TelaProprietarios`, `TelaCarros`, etc.
- **lib/presentation/widgets**: Widgets reutilizáveis, como `ProprietarioCard`, `CarroDialog`, etc.
- **lib/services**: Controladores responsáveis por gerenciar o estado e a paginação.  
  Ex.: `CarroController` e `ChecklistController`
- **lib**: Arquivos de configuração e inicialização do aplicativo.  
  Ex.: `main.dart` e `aplicativo.dart`
- **mock**: Dados falsos para teste e inicialização do banco de dados (gerados automaticamente usando o site [mockaroo.com](https://www.mockaroo.com/)).

### Fluxo de Funcionamento

1. **Cadastro e Gerenciamento de Proprietários**  
   Na tela principal, os proprietários são listados. Para editar ou remover, utilize os botões correspondentes nas cartas de exibição. Para adicionar um novo proprietário, clique no botão flutuante. Para acessar as configurações, clique no ícone de engrenagem.

2. **Gerenciamento de Carros**  
   Após selecionar um proprietário, a tela de carros é exibida, com a opção de adicionar um novo carro ou editar/excluir os existentes.  

3. **Checklists e Itens**  
   Ao selecionar um carro, os checklists relacionados são mostrados. Cada checklist pode ter diversos itens que podem ser editados ou marcados conforme necessário.  

4. **Relatórios e Operações em Massa**  
   As funções de relatório e limpeza dos dados (como apagar todos os registros e adicionar dados falsos para teste) estão disponíveis através do diálogo de configurações.  

### Dependências

As dependências do projeto podem ser conferidas no [pubspec.yaml](c:/Users/T-GAMER/Documents/oficina/pubspec.yaml):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.4.1
  logger: ^2.5.0
  signals_flutter: ^6.0.2
  csv: ^6.0.0
  infinite_scroll_pagination: ^4.1.0
  flutter_slidable: ^4.0.0
```

### Como Executar

Para executar o aplicativo, é necessário [ter o Flutter instalado e configurado](https://flutter.dev/docs/get-started/install). 

1. Clone o repositório:  
   ```bash
   git clone https://github.com/jeancarlopolo/app_oficina_flutter
    ```
2. Acesse o diretório do projeto:
    ```bash
    cd app_oficina_flutter
    ```

3. Instale as dependências:
    ```bash
    flutter pub get
    ```

4. Execute o aplicativo:
    ```bash
    flutter run
    ```

Um emulador ou dispositivo físico deve estar conectado para a execução do aplicativo.

Um apk de exemplo pré-compilado também está disponível (app-release.apk) para instalação em dispositivos Android.
   
### Considerações Finais

O aplicativo foi desenvolvido com foco na facilidade de uso e na organização do fluxo de dados, utilizando um banco de dados SQLite com controle de transações e atualização dinâmica das interfaces através de _signals_ e paginadores.

---
