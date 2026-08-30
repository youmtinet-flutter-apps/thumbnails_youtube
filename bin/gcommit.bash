#!/bin/bash
DIFF=$(git diff --staged)

if [ -z "$DIFF" ]; then
  echo "No staged changes."
  exit 1
fi

MSG=$(echo "$DIFF" | ollama launch qwen:7b "Write a concise conventional-commit style message for this diff. Output only the message:")

echo "Ollama suggests:"
echo "$MSG"
echo ""
read -p "(a)ccept / (r)efine with Claude / (e)dit / (c)ancel: " choice

case "$choice" in
  a) git commit -m "$MSG" ;;
  r)
    REFINED=$(claude -p "Improve this commit message to be clearer and more accurate, based on this diff. Output only the message.

Diff:
$DIFF

Draft message:
$MSG")
    echo "Claude refined: $REFINED"
    read -p "Commit with this? (y/n) " ok
    [ "$ok" = "y" ] && git commit -m "$REFINED"
    ;;
  e) git commit ;;
  *) echo "Cancelled" ;;
esac