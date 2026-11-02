# ECHO-19 — Alpha 0.1

Projeto Roblox original de terror psicológico, exploração e suspense em uma instalação subterrânea.

**Status: protótipo técnico, ainda não testado dentro do Roblox.**

## Funcionalidades iniciais
- Elevador, corredores, átrio e manutenção gerados em Luau no servidor.
- Iluminação industrial e elementos simples do cenário.
- Terminal de arquivos, gravador de frequência simulada, porta automatizada.
- Registro narrativo de manutenção e aparição temporária do Observador.
- Interface com botões de toque para Android e suporte à tecla R no PC.
- Compilação Rojo automática e publicação manual pela Roblox Open Cloud.

## Percurso de teste
1. Do elevador inicial, vá ao átrio.
2. Consulte o terminal à esquerda para liberar o botão do gravador.
3. Aproxime-se da porta de manutenção e toque em EMITIR ECO.
4. Leia o registro dentro do setor de manutenção.

## Publicação
- Universe ID: 3569802459
- Place ID: 9591561150
- Secret no GitHub Actions: ROBLOX_API_KEY (permissão universe-places:write).
- Abra GitHub > Actions > ECHO-19 - Publicacao manual > Run workflow.
- Use Saved primeiro para verificar o upload e Published para tornar a versão jogável no Roblox.
- Um segundo workflow apenas compila o jogo quando o código muda; não publica automaticamente.

Não compartilhe chaves, senhas nem cookies Roblox.

## Limites
- A Alpha ainda usa avatar padrão. Animação personalizada de personagens não foi implementada.
- Porta e introdução têm transições criadas com TweenService.
- Observador é um placeholder, sem perseguição ou IA avançada.
- Sem salvamento, áudio ou mapa artístico final.
- Compilação bem-sucedida não substitui testes reais de jogabilidade.

## Documentação
- https://create.roblox.com/docs/cloud/guides/usage-place-publishing
- https://create.roblox.com/docs/cloud/auth/api-keys
- https://rojo.space/docs/v7/
