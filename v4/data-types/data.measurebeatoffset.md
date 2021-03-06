---
layout: sidebar
sidebar: s1
version: "v4"
title: "data.MEASUREBEATOFFSET"
---
<div class="specPage">
   <div class="datatypeSpec">
      <h3 id="data.MEASUREBEATOFFSET">data.MEASUREBEATOFFSET</h3>
      <div class="specs">
         <div class="desc">A count of measures plus a beat location, i.e., (\+|-)?[0-9]+m\+[0-9]+(\.?[0-9]*)?.
            The
            measure count is the number of barlines crossed by the event, while the beat location
            is a
            timestamp expressed as a beat with an optional fractional part. The measure number
            must be in
            the range of preceding measures to the number of remaining measures. A value with
            a positive
            measure number, such as "1m+3", indicates a point in the following measure, while
            a value with
            a negative measure number, such as "-1m+3", marks a point in the preceding measure.
            The beat
            number must be in the range from 0 to the numerator of the time signature plus 1.
            For example,
            in 6/8 the beat number must be within the range from 0 (the left barline) to 7 (the
            right
            barline). A value with a measure number of "0", such as "0m+2", indicates a point
            within the
            current measure.
         </div>
         <div class="facet module">
            <div class="label">Module</div>
            <div class="statement text">MEI</div>
         </div>
         <div class="facet usedBy" id="usedBy">
            <div class="label">Used by</div>
            <div class="statement list">
               <div class="classBox dtBox" title="Attribute Classes">
                  <div class="classHeading"><label class="classLabel">Attribute Classes</label><span class="classDesc">These class-based attributes use data.MEASUREBEATOFFSET</span></div>
                  <div class="classContent"><span class="ident attclass" data-ident="att.origin.timestamp.logical" data-module="MEI.shared"><a class="classLink" title="Attributes that identify a musical range in terms of musical time." href="{{ site.baseurl }}/{{ page.version }}/attribute-classes/att.origin.timestamp.logical.html">att.origin.timestamp.logical</a>/<span title="encodes the starting point of musical material in terms of musical time, i.e., a (potentially negative) count of measures plus a beat location.">@origin.tstamp</span></span></div>
               </div>
            </div>
         </div>
         <div class="facet declaration">
            <div class="label">Declaration</div>
            <div class="statement declaration">
               <div class="code" xml:space="preserve" data-lang="ODD"><code>
                     <div class="indent1 indent"><span data-indentation="1" class="element">&lt;macroSpec <span class="attribute">ident=</span><span class="attributevalue">"data.MEASUREBEATOFFSET"</span> <span class="attribute">module=</span><span class="attributevalue">"MEI"</span> <span class="attribute">type=</span><span class="attributevalue">"dt"</span>&gt;</span>
                        
                        <div class="indent2 indent"><span data-indentation="2" class="element">&lt;desc&gt;</span>A count of measures plus a beat location, i.e., (\+|-)?[0-9]+m\+[0-9]+(\.?[0-9]*)?.
                           The
                           measure count is the number of barlines crossed by the event, while the beat location
                           is a
                           timestamp expressed as a beat with an optional fractional part. The measure number
                           must be in
                           the range of preceding measures to the number of remaining measures. A value with
                           a positive
                           measure number, such as "1m+3", indicates a point in the following measure, while
                           a value with
                           a negative measure number, such as "-1m+3", marks a point in the preceding measure.
                           The beat
                           number must be in the range from 0 to the numerator of the time signature plus 1.
                           For example,
                           in 6/8 the beat number must be within the range from 0 (the left barline) to 7 (the
                           right
                           barline). A value with a measure number of "0", such as "0m+2", indicates a point
                           within the
                           current measure.<span data-indentation="2" class="element">&lt;/desc&gt;</span></div>
                        
                        <div class="indent2 indent"><span data-indentation="2" class="element">&lt;content&gt;</span>
                           
                           <div class="indent3 indent"><span data-indentation="3" class="element">&lt;rng:data <span class="attribute">type=</span><span class="attributevalue">"token"</span>&gt;</span>
                              
                              <div class="indent4 indent"><span data-indentation="4" class="element">&lt;rng:param <span class="attribute">name=</span><span class="attributevalue">"pattern"</span>&gt;</span><div class="indent5 indent">(\+|-)?[0-9]+m\+[0-9]+(\.[0-9]*)?</div><span data-indentation="4" class="element">&lt;/rng:param&gt;</span></div>
                              <span data-indentation="3" class="element">&lt;/rng:data&gt;</span></div>
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