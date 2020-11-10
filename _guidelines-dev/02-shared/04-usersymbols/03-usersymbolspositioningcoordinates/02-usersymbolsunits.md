---
sectionid: usersymbolsUnits
title: "Units"
version: "dev"
---

There are two types of units used by MEI: Staff units and units of the output coordinate system. Units of the output coordinate system can be translated to physical real world distances by means of the **@vu.height** and **@page.scale** of a {% include link elem="scoreDef" %} element. Real world units are multiplied by the value of **@page.scale** to get the corresponding value in output coordinate units.

If an element is scaled using the **@scale** attribute, the actual size of the units changes accordingly.
