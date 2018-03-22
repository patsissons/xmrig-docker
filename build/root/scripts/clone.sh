#!/bin/sh

if [ -d xmrig/.git ]; then
  git -C xmrig pull
else
  git clone $REPO_URI xmrig
  git -C xmrig apply ../donate-level.patch
fi
