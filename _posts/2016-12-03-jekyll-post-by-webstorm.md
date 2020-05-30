---
layout: post
title: Jekyll Post by using webstorm file template
date: 2016-12-03 20:41:37 +0900
type: post
published: true
comments: true
categories: [Blog]
tags: [Jekyll, Webstorm]
type: note
---

1. Open Preferences dialog in webstorm
- Press &#8984; \+ `,` (command key and ',')

2. Search for 'File and Code Templates'

3. Click `+` image in Files tab in 'File and Code Templates'
- Enter 'Jekyll Post' in Name field
- Enter 'md' in Extension field
- Enter below in the template

```YAML
---
layout: post
title: $title
date: ${YEAR}-${MONTH}-${DAY} ${HOUR}:${MINUTE}:${SECOND} +0900
type: post
published: true
comments: true
categories: [$categories]
tags: [$tags]
---
```


참고:

- [Webstorm help page about editing file templates](https://www.jetbrains.com/help/webstorm/2016.3/creating-and-editing-file-templates.html)
- [Jekyll front matter YAML](http://jekyllrb-ko.github.io/docs/frontmatter/) (Korean)
