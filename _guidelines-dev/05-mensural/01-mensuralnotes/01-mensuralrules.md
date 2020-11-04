---
sectionid: mensuralRules
title: "Alteration and Imperfection"
version: "dev"
---

In ternary mensurations, the ambiguity between the note shape and its actual duration requires specific attention. The rules of mensural notation can require the alteration or the imperfection of a note; that is, an increase or reduction in its performed duration. In these cases, if the encoding is intended to be used for more than just graphically representing the notation, encoding only the note shape by means of the **@dur** attribute alone is insufficient. In that case, in addition to encoding the duration sign in the **@dur** attribute, it is recommended to encode its performed duration in the **@dur.quality** attribute. The **@dur.quality** attribute specifies the length of a note according to the contextual rules of mensural notation. Its values, listed below, are adopted from the original Latin terms:

{:.gloss}
**perfecta**: Three times the duration of the note in the next smaller degree
{:.gloss}
**imperfecta**: Two times the duration of the note in the next smaller degree
{:.gloss}
**altera**: Twice the original duration of the note (only usable in perfect mensurations)
{:.gloss}
**minor**: Category of a regular semibrevis in Ars antiqua, equivalent to a third of a brevis
{:.gloss}
**maior**: Category of an altered semibrevis in Ars antiqua, equivalent to two minor semibrevis
{:.gloss}
**duplex**: One of the three categories of a longa in Ars antiqua ('duplex', 'perfecta', and 'imperfecta')
{:.gloss}

The last three values are to be used exclusively in *Ars antiqua* mensural notation, where "maior" and "minor" refer to types of *semibreves*, and "duplex" refers to a type of *longa*. Examples of each of these six values are presented below. In these examples, the ‘voice’ staff renders the notes in the code snippet, and the ‘reference’ staff, together with the dotted barlines, are shown to help to visualize the relative values of the notes in the ‘voice’ staff.


The following example illustrates an **alteration** (the second *brevis*) in *modus minor perfectus*. Notice that the second *brevis* has doubled its regular value, it has been altered, unlike the first one.
{% include verovio example="alteration.mei" encoding=true %}

It is possible to omit the **@dur.quality** attribute in a note when the performed duration of the note is the default value provided by the mensuration. In this case, the *longas* are perfect, just as the mensuration (*perfect modus minor*) indicates. Therefore, the **@dur.quality** attribute can be omitted for the two *longas*.
{% include mei example="mensural/mensural-sample164.xml" valid="" %}
The same applies to the examples that follow.


The following example illustrates an **imperfection** (the two *longae*) in *modus minor perfectus* with the same *longa*-*brevis*-*brevis*-*longa* sequence but with an additional *dot of division* between the two *breves*. Notice that here the *longae* have been imperfected, unlike the previous example in which they kept the perfect value indicated by the mensuration.
{% include verovio example="imperfection.mei" encoding=true %}


The following example in *modus minor imperfectus* illustrates the use of a dot of augmentation following the *longa*. Notice that the *longa*, which is supposed to be imperfect according to the mensuration, has a perfect value due to the augmentation dot.
{% include verovio example="augmentation.mei" encoding=true %}


Finally, the following example illustrates the **@dur.quality** values related to the *Ars antiqua* style, for *perfect modus*, with the breve equivalents notated in the lower staff for reference (as in the previous examples).
{% include verovio example="ars_antiqua.mei" encoding=true %}

**Note:** In *Ars Antiqua*, only the *longa* could be "perfecta" / "imperfecta" and the *brevis* could have a regular value ("recta") or be "altera". In the *Ars nova*, principles of imperfection and alteration were extended into the other note levels (*brevis*-*semibrevis* and *semibrevis*-*minima*). This means that the *breves* in *Ars antiqua* do not have a "perfecta" / "imperfecta" quality, and this is why there is no **@dur.quality** attribute for the *breves* in the previous example. However, the *brevis* can have a ternary division (indicated by *tempus=”3”*), being divided either into three (equal) *minor semibreves* or into a *minor*-*maior* pair of *semibreves*.
The encoding also allows for the possibility of encoding a binary division of the breve in *Ars antiqua* notations: the  indication *tempus=”2”* indicates the breve is divided into two equal *semibreves*. This is why in this example with *tempus="3"*, the *semibreves* do have a **@dur.quality** attribute (with values "minor" or "maior").

An alternative encoding---removing the **@dur.quality** attributes for notes which lengths are not modified from their default values (i.e., the perfect long and the minor *semibreves*)---would be:
{% include mei example="mensural/mensural-sample165.xml" valid="" %}

The conjunct use of the **@dur** and **@dur.quality** attributes is generally enough to encode the duration of a note—and, as indicated before, one could even remove **@dur.quality** when its value is in agreement with the mensuration. However, there are cases (e.g., partial imperfection) where the values of **@dur.quality** are not enough to provide the note's duration.
