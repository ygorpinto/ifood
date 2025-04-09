# 🍔 Clone do iFood

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-4285F4?style=for-the-badge&logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

</div>

<div align="center">
  <img src="https://via.placeholder.com/800x400.png?text=iFood+Clone" alt="iFood Clone Banner" style="border-radius: 10px; margin: 20px 0;">
</div>

## 📋 Índice

- [📱 Visão Geral](#-visão-geral)
- [✨ Características](#-características)
- [🚀 Começando](#-começando)
- [📊 Estrutura do Projeto](#-estrutura-do-projeto)
- [📸 Capturas de Tela](#-capturas-de-tela)
- [🛠️ Tecnologias Utilizadas](#️-tecnologias-utilizadas)
- [📋 Funcionalidades](#-funcionalidades)
- [👨‍💻 Desenvolvimento](#-desenvolvimento)
- [📝 Melhorias Futuras](#-melhorias-futuras)
- [🤝 Contribuição](#-contribuição)
- [📄 Licença](#-licença)

## 📱 Visão Geral

Este projeto é um clone do aplicativo iFood, desenvolvido com Flutter, implementando as principais funcionalidades da aplicação original. O projeto foi estruturado seguindo a arquitetura MVVM (Model-View-ViewModel), com gestão de estado usando Provider, e navegação com go_router.

## ✨ Características

- 🏗️ **Arquitetura MVVM**: Separação clara entre Models, ViewModels e Views
- 🔄 **Gestão de Estado**: Provider para gerenciamento centralizado de estado
- 🧭 **Navegação**: go_router para navegação entre telas
- 🪝 **Hooks**: flutter_hooks para simplificar o gerenciamento de estado local
- 🎨 **Tema Personalizado**: Temas claro e escuro com as cores do iFood
- 📱 **Responsividade**: Design que se adapta a diferentes tamanhos de tela
- 🎬 **Animações**: Transições suaves entre telas
- 🧩 **Componentes Reutilizáveis**: Cards, botões e elementos de UI consistentes

## 🚀 Começando

Essas instruções permitirão que você obtenha uma cópia do projeto e execute-o em sua máquina local para desenvolvimento e testes.

### 📋 Pré-requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) (v3.2.0 ou superior)
- [Dart](https://dart.dev/get-dart) (v3.0.0 ou superior)
- Editor de código recomendado: [Visual Studio Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)

### 🔧 Instalação

1. **Clone o repositório**

```bash
git clone https://github.com/seu-usuario/ifood_clone.git
cd ifood_clone
```

2. **Instale as dependências**

```bash
flutter pub get
```

3. **Verifique sua configuração do Flutter**

```bash
flutter doctor
```

### ⚙️ Executando o projeto

Você pode executar o aplicativo em um emulador ou em seu dispositivo físico:

- **Para executar em um emulador**

```bash
# Inicie seu emulador primeiro
flutter run
```

- **Para executar em um dispositivo físico**

```bash
# Conecte seu dispositivo via USB com a depuração USB ativada
flutter run
```

- **Para gerar uma versão de lançamento APK**

```bash
flutter build apk --release
```

## 📊 Estrutura do Projeto

```
lib/
  ├── core/
  │   ├── routes/       # Configuração de rotas
  │   ├── theme/        # Temas e cores
  │   └── widgets/      # Widgets reutilizáveis
  ├── data/
  │   ├── mocks/        # Dados mock para testes
  │   │   └── json/     # Arquivos JSON para simular API
  │   ├── models/       # Modelos de dados
  │   └── repositories/ # Acesso aos dados
  ├── models/           # Definição das classes de modelo
  │   ├── restaurant.dart
  │   ├── menu_item.dart
  │   ├── cart_item.dart
  │   └── user.dart
  ├── views/            # Telas da aplicação
  │   ├── auth/         # Autenticação (login/cadastro)
  │   ├── cart/         # Carrinho de compras
  │   ├── home/         # Tela principal
  │   ├── orders/       # Histórico de pedidos
  │   ├── restaurant/   # Listagem e detalhes de restaurantes
  │   ├── splash/       # Tela inicial
  │   └── main/         # Shell principal com navegação
  ├── viewmodels/       # Lógica de negócios e estado
  │   ├── auth_provider.dart
  │   ├── cart_provider.dart
  │   └── theme_provider.dart
  └── main.dart         # Ponto de entrada da aplicação
```

## 📸 Capturas de Tela

<div align="center">
  <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 10px;">
    <img src="https://via.placeholder.com/250x500.png?text=Splash" alt="Splash" width="250" style="border-radius: 8px;">
    <img src="https://via.placeholder.com/250x500.png?text=Home" alt="Home" width="250" style="border-radius: 8px;">
    <img src="https://via.placeholder.com/250x500.png?text=Detalhes" alt="Detalhes" width="250" style="border-radius: 8px;">
    <img src="https://via.placeholder.com/250x500.png?text=Carrinho" alt="Carrinho" width="250" style="border-radius: 8px;">
    <img src="https://via.placeholder.com/250x500.png?text=Pedidos" alt="Pedidos" width="250" style="border-radius: 8px;">
    <img src="https://via.placeholder.com/250x500.png?text=Login" alt="Login" width="250" style="border-radius: 8px;">
  </div>
</div>

## 🛠️ Tecnologias Utilizadas

- **[Flutter](https://flutter.dev/)**: Framework UI para desenvolvimento multiplataforma
- **[Provider](https://pub.dev/packages/provider)**: Gerenciamento de estado
- **[go_router](https://pub.dev/packages/go_router)**: Navegação
- **[flutter_hooks](https://pub.dev/packages/flutter_hooks)**: Hooks para Flutter
- **[cached_network_image](https://pub.dev/packages/cached_network_image)**: Carregamento e cache de imagens

## 📋 Funcionalidades

### 👤 Autenticação
- **Login/Cadastro**: Sistema de autenticação simulado com dados locais
- **Perfil de Usuário**: Gerenciamento de informações pessoais

### 🏠 Tela Principal
- **Categorias**: Navegação por categorias de restaurantes
- **Restaurantes em Destaque**: Listagem de restaurantes populares
- **Busca**: Pesquisa de restaurantes por nome

### 🍽️ Restaurantes
- **Listagem**: Exibição de restaurantes por categoria
- **Detalhes**: Informações detalhadas sobre cada restaurante
- **Menu**: Visualização dos itens disponíveis

### 🛒 Carrinho de Compras
- **Adicionar Itens**: Seleção de produtos com opções de personalização
- **Gerenciar Itens**: Aumentar/diminuir quantidade, remover itens
- **Resumo do Pedido**: Subtotal, taxa de entrega e valor total

### 📦 Pedidos
- **Histórico**: Visualização de pedidos anteriores
- **Status**: Acompanhamento do status do pedido

### 🎨 Tema
- **Modo Claro/Escuro**: Alternância entre temas

## 👨‍💻 Desenvolvimento

### Clonar e Contribuir
1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Implemente suas mudanças
4. Commit suas alterações (`git commit -m 'Adiciona nova feature'`)
5. Push para a branch (`git push origin feature/nova-feature`)
6. Abra um Pull Request

### Executando Testes
```bash
flutter test
```

## 📝 Melhorias Futuras

- [ ] Integração com backend real
- [ ] Autenticação com Firebase
- [ ] Geolocalização para busca de restaurantes próximos
- [ ] Notificações push para atualizações de pedidos
- [ ] Métodos de pagamento
- [ ] Testes unitários e de integração
- [ ] Suporte para múltiplos idiomas
- [ ] Modo offline com armazenamento local
- [ ] Acessibilidade ampliada

## 🤝 Contribuição

Contribuições são o que fazem a comunidade open source um lugar incrível para aprender, inspirar e criar. Qualquer contribuição que você fizer será **muito apreciada**.

1. Faça um Fork do projeto
2. Crie uma Branch para sua Feature (`git checkout -b feature/AmazingFeature`)
3. Adicione suas mudanças (`git add .`)
4. Comite suas mudanças (`git commit -m 'Add some AmazingFeature'`)
5. Faça o Push da Branch (`git push origin feature/AmazingFeature`)
6. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<div align="center">

⭐️ Desenvolvido com 💙 e Flutter

[⬆ Voltar ao topo](#-clone-do-ifood)

</div>
