---
layout: sidebar
sidebar: s1
version: "v4"
title: "SVG"
sectionid: "svg"
---

In order to use Scalable Vector Graphics (SVG) in MEI, a new *module* needs to be compiled into ODD (see {% include link id="meicustomization" %} for an introduction on how to do that). In order to do that, you need to enter the following `<moduleRef>` into the `<schemaSpec>` of your ODD file:

{% include mei example="svg-moduleRef.txt" valid="" %}

With this addition, which can be added to any of the provided customizations of MEI (see {% include link id="meiprofiles" %}), the `<svg>` element becomes available everywhere `model.graphicLike` (i.e. the {% include link elem="graphic" %} element) is currently allowed, that is: inside of {% include link elem="fig" %}, {% include link elem="incip" %}, {% include link elem="surface" %}, and {% include link elem="zone" %}.

In the following example, an `<svg:path>` element is inserted into a {% include link elem="surface" %}. It would now be possible for measures or other music features to point to the rectangular {% include link elem="zone" %} in MEI namespace, or the fancy shaped `<svg:path>` using their **@facs** attribute (see {% include link id="facsimileElements" %} for that mechanism). It's equally possible to use SVG content inside figures on titlepages or anywhere else.

{% include mei example="svg-example.txt" valid="" %}

Of course it's possible to allow elements in SVG namespace in other places in MEI as well, by adjusting the model classes that the SVG namespace shall join.
