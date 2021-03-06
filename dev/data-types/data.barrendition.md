---
layout: sidebar
sidebar: s1
version: "dev"
title: "data.BARRENDITION"
---
<div class="specPage">
   <div class="datatypeSpec">
      <h3 id="data.BARRENDITION">data.BARRENDITION</h3>
      <div class="specs">
         <div class="desc">Renderings of bar lines. Some values correspond to the Western Musical Symbols portion
            of
            the Unicode Standard.
         </div>
         <div class="facet module">
            <div class="label">Module</div>
            <div class="statement text">MEI</div>
         </div>
         <div class="facet usedBy" id="usedBy">
            <div class="label">Used by</div>
            <div class="statement list">
               <div class="classBox dtBox" title="Attribute Classes">
                  <div class="classHeading"><label class="classLabel">Attribute Classes</label><span class="classDesc">These class-based attributes use data.BARRENDITION</span></div>
                  <div class="classContent"><span class="ident attclass" data-ident="att.measure.log" data-module="MEI.cmn"><a class="classLink" title="Logical domain attributes. The n attribute contains a name or number associated with the measure (Read, p. 445). Often, this is an integer, but not always. For example, some measures, especially incomplete measures or those under an ending mark, may have labels that contain an integer plus a suffix, such as '12a'. Measures may even have labels, especially in editorial or analytical uses of MEI, that are entirely non-numeric strings. Measure numbers may be machine-generated instead of encoding them in the markup. However, an explicit measure number should restart numbering with the given value. The join attribute may be used to indicate another measure which metrically completes the current, incomplete one." href="{{ site.baseurl }}/{{ page.version }}/attribute-classes/att.measure.log.html">att.measure.log</a>/<span title="Indicates the visual rendition of the left bar line. It is present here only for facilitation of translation from legacy encodings which use it. Usually, it can be safely ignored.">@left</span></span><span class="ident attclass" data-ident="att.measure.log" data-module="MEI.cmn"><a class="classLink" title="Logical domain attributes. The n attribute contains a name or number associated with the measure (Read, p. 445). Often, this is an integer, but not always. For example, some measures, especially incomplete measures or those under an ending mark, may have labels that contain an integer plus a suffix, such as '12a'. Measures may even have labels, especially in editorial or analytical uses of MEI, that are entirely non-numeric strings. Measure numbers may be machine-generated instead of encoding them in the markup. However, an explicit measure number should restart numbering with the given value. The join attribute may be used to indicate another measure which metrically completes the current, incomplete one." href="{{ site.baseurl }}/{{ page.version }}/attribute-classes/att.measure.log.html">att.measure.log</a>/<span title="Indicates the function of the right bar line and is structurally important.">@right</span></span><span class="ident attclass" data-ident="att.barLine.log" data-module="MEI.shared"><a class="classLink" title="Logical domain attributes." href="{{ site.baseurl }}/{{ page.version }}/attribute-classes/att.barline.log.html">att.barLine.log</a>/<span title="Records the appearance and usually the function of the bar line.">@form</span></span></div>
               </div>
            </div>
         </div>
         <div class="facet allowedValues" id="allowedValues">
            <div class="label">Allowed Values</div>
            <div class="statement list">
               <div class="dataValueBox" id="dashed"><span class="dataValue ident">dashed</span><span class="dataValue desc">Dashed line (Unicode 1D104).</span></div>
               <div class="dataValueBox" id="dotted"><span class="dataValue ident">dotted</span><span class="dataValue desc">Dotted line.</span></div>
               <div class="dataValueBox" id="dbl"><span class="dataValue ident">dbl</span><span class="dataValue desc">(Unicode 1D101).</span></div>
               <div class="dataValueBox" id="dbldashed"><span class="dataValue ident">dbldashed</span><span class="dataValue desc">Double dashed line.</span></div>
               <div class="dataValueBox" id="dbldotted"><span class="dataValue ident">dbldotted</span><span class="dataValue desc">Double dotted line.</span></div>
               <div class="dataValueBox" id="end"><span class="dataValue ident">end</span><span class="dataValue desc">(Unicode 1D102).</span></div>
               <div class="dataValueBox" id="invis"><span class="dataValue ident">invis</span><span class="dataValue desc">Bar line not rendered.</span></div>
               <div class="dataValueBox" id="rptstart"><span class="dataValue ident">rptstart</span><span class="dataValue desc">Repeat start (Unicode 1D106).</span></div>
               <div class="dataValueBox" id="rptboth"><span class="dataValue ident">rptboth</span><span class="dataValue desc">Repeat start and end.</span></div>
               <div class="dataValueBox" id="rptend"><span class="dataValue ident">rptend</span><span class="dataValue desc">Repeat end (Unicode 1D107).</span></div>
               <div class="dataValueBox" id="single"><span class="dataValue ident">single</span><span class="dataValue desc">(Unicode 1D100).</span></div>
            </div>
         </div>
         <div class="facet declaration">
            <div class="label">Declaration</div>
            <div class="statement declaration">
               <div class="code" xml:space="preserve" data-lang="ODD"><code>
                     <div class="indent1 indent"><span data-indentation="1" class="element">&lt;macroSpec <span class="attribute">ident=</span><span class="attributevalue">"data.BARRENDITION"</span> <span class="attribute">module=</span><span class="attributevalue">"MEI"</span> <span class="attribute">type=</span><span class="attributevalue">"dt"</span>&gt;</span>
                        
                        <div class="indent2 indent"><span data-indentation="2" class="element">&lt;desc&gt;</span>Renderings of bar lines. Some values correspond to the Western Musical Symbols portion
                           of
                           the Unicode Standard.<span data-indentation="2" class="element">&lt;/desc&gt;</span></div>
                        
                        <div class="indent2 indent"><span data-indentation="2" class="element">&lt;content&gt;</span>
                           
                           <div class="indent3 indent"><span data-indentation="3" class="element">&lt;valList <span class="attribute">type=</span><span class="attributevalue">"closed"</span>&gt;</span>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"dashed"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Dashed line (Unicode 1D104).<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"dotted"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Dotted line.<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"dbl"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>(Unicode 1D101).<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"dbldashed"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Double dashed line.<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"dbldotted"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Double dotted line.<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"end"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>(Unicode 1D102).<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"invis"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Bar line not rendered.<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"rptstart"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Repeat start (Unicode 1D106).<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"rptboth"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Repeat start and end.<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"rptend"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>Repeat end (Unicode 1D107).<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;valItem <span class="attribute">ident=</span><span class="attributevalue">"single"</span>&gt;</span>
                                 
                                 <div class="indent5 indent"><span data-indentation="5" class="element">&lt;desc&gt;</span>(Unicode 1D100).<span data-indentation="5" class="element">&lt;/desc&gt;</span></div>
                                 <span data-indentation="4" class="element">&lt;/valItem&gt;</span></div>
                              <span data-indentation="3" class="element">&lt;/valList&gt;</span></div>
                           <span data-indentation="2" class="element">&lt;/content&gt;</span></div>
                        <span data-indentation="1" class="element">&lt;/macroSpec&gt;</span></div></code></div>
            </div>
         </div>
      </div><script type="text/javascript">
            
            var tabbedFacets = document.querySelectorAll('.facet ul.tab');
            
            var tabClick = function(e) {
                var style = e.target.getAttribute('data-display');
                var facetId = e.target.parentNode.parentNode.parentNode.parentNode.id;
                setTabs(facetId,style)
            }
            
            for(var facetUl of tabbedFacets) {
                var facetElem = facetUl.parentNode.parentNode;
                var facetId = facetElem.id;
                var storageName = 'meiSpecs_' + facetId + '_display';
                var defaultValue = facetUl.children[0].children[0].getAttribute('data-display');
                
                if(localStorage.getItem(storageName) === null) {
                    setTabs(facetElem.id,defaultValue);
                } else {
                    setTabs(facetElem.id,localStorage.getItem(storageName));
                }
                
                var tabs = facetUl.querySelectorAll('.tab-item a');
                
                for(var tab of tabs) {
                    tab.addEventListener('click',tabClick);
                }
                
            }
            
            function setTabs(facetId,style) {
                
                var storageName = 'meiSpecs_' + facetId + '_display';
                localStorage.setItem(storageName,style);
                
                var facetElem = document.getElementById(facetId);
                
                var oldTab = facetElem.querySelector('.displayTab.active');
                oldTab.classList.remove('active');
                
                var newTab = document.getElementById(facetId + '_' + style + '_tab');
                newTab.classList.add('active');
                
                var oldBox = facetElem.querySelector('.active.facetTabbedContent');
                oldBox.classList.remove('active');
                oldBox.style.display = 'none';
                
                var newBox = document.getElementById(facetId + '_tabbedContent_' + style);
                newBox.classList.add('active');
                newBox.style.display = 'block';
                
            }
        </script></div>
</div>