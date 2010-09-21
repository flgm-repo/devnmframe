
var k_push_js_revision='$Rev: 10199 $';var k_button1={"Set_Cookie":function(name,value,expires,path,domain,secure)
{var today=new Date();today.setTime(today.getTime());if(expires)
expires=expires*1000*60*60*24;var expires_date=new Date(today.getTime()+(expires));document.cookie=name+"="+escape(value)+
((expires)?";expires="+expires_date.toGMTString():"")+
((path)?";path="+path:"")+
((domain)?";domain="+domain:"")+
((secure)?";secure":"");},"Get_Cookie":function(name)
{var start=document.cookie.indexOf(name+"=");var len=start+name.length+1;if((!start)&&(name!=document.cookie.substring(0,name.length)))
return null;if(start==-1)return null;var end=document.cookie.indexOf(";",len);if(end==-1)end=document.cookie.length;return unescape(document.cookie.substring(len,end));},"get_main_domain":function()
{var domain=document.domain;if(document.domain!="undefined"&&document.domain!="")
{if(document.domain=='localhost')
main_domain='';else
{var dots=domain.split(/\./g);var tld=dots[dots.length-1];var sTlds=['COM','EDU','NET','ORG','GOV','MIL','INT'];var mDotsLength=3;for(var i in sTlds)
{if(sTlds[i]==tld.toUpperCase())
mDotsLength=2;}
if(dots.length>mDotsLength)
{main_domain=dots.slice(dots.length-mDotsLength).join('.');}
else
{main_domain=domain;}}}
else
main_domain='';return main_domain;}}
if(typeof(k_push_vars)=="undefined")
k_push_vars={}
var k_push={"after_time":20,"popup_w":380,"popup_h":185,"popup_h_brand":200,"myWidth":0,"myHeight":0,"popup_open":false,"counter":0,"branding":1,"lastPosy":null,"cookie_expiration_time_no":21,"getSize":function(){if(typeof(window.innerWidth)=='number'){k_push.myWidth=window.innerWidth;k_push.myHeight=window.innerHeight;}else if(document.documentElement&&(document.documentElement.clientWidth||document.documentElement.clientHeight)){k_push.myWidth=document.documentElement.clientWidth;k_push.myHeight=document.documentElement.clientHeight;}else if(document.body&&(document.body.clientWidth||document.body.clientHeight)){k_push.myWidth=document.body.clientWidth;k_push.myHeight=document.body.clientHeight;}},"getScrollY":function(){var scrOfY=0;if(typeof(window.pageYOffset)=='number')
scrOfY=window.pageYOffset;else if(document.body&&(document.body.scrollTop))
scrOfY=document.body.scrollTop;else if(document.documentElement&&(document.documentElement.scrollTop))
scrOfY=document.documentElement.scrollTop;return scrOfY;},"mousePos":function(e){if(k_push.popup_open||k_push_vars.popup_manual)
return;k_push.getSize();var posy=0;if(!e)var e=window.event;if(e.pageX||e.pageY)
posy=e.pageY;else if(e.clientX||e.clientY)
posy=e.clientY+k_push.getScrollY();if(k_push.lastPosy==null)
k_push.lastPosy=posy;else
{if(k_push.lastPosy<posy)
k_push.lastPosy=posy;else
{if(posy<k_push.getScrollY()+15)
k_push.openPopup();}}},"popup_init":function(){k_push.getSize();document.onmousemove=k_push.mousePos;var maskBG=document.createElement('div');maskBG.setAttribute('id','k_maskBG');document.body.appendChild(maskBG);var popup=document.createElement('div');var use_brand=k_push.branding&&!k_push_vars.no_brand?true:false;popup.setAttribute('id','k_popup');popup.style.width=(k_push_vars.popup_w?k_push_vars.popup_w:k_push.popup_w)+'px';if(!k_push_vars.popup_h)
popup.style.lineHeight="normal";popup.style.color=(k_push_vars.popup_font_color)?k_push_vars.popup_font_color:'#000000';k_push.ff_link_id=(k_push_vars.ff_link_id)?k_push_vars.ff_link_id:'kampylink';k_push.header=(k_push_vars.header)?k_push_vars.header:'Your feedback is important to us!';k_push.question=(k_push_vars.question)?k_push_vars.question:'Would you be willing to give us a short (1 minute) feedback?';k_push.footer=(k_push_vars.footer)?k_push_vars.footer:'Thank you for helping us improve our website';k_push.yes=(k_push_vars.yes)?k_push_vars.yes:'Yes';k_push.no=(k_push_vars.no)?k_push_vars.no:'No';k_push.yes_background=(k_push_vars.yes_background)?k_push_vars.yes_background:'#76AC78';k_push.no_background=(k_push_vars.no_background)?k_push_vars.no_background:'#8D9B86';k_push.dir=(k_push_vars.text_direction=='rtl')?'rtl':'ltr';k_push.remind=k_push_vars.remind?k_push_vars.remind:'Remind me later';k_push.remind_font_color=(k_push_vars.remind_font_color)?k_push_vars.remind_font_color:'#3882C3';if(k_push.dir=='ltr')
{k_push.yes_float='left';k_push.no_float='right';}
else
{k_push.yes_float='right';k_push.no_float='left';}
k_push.images_dir=(k_push_vars.images_dir)?k_push_vars.images_dir:'http://cf.kampyle.com/';k_push.separator=k_push_vars.popup_separator?k_push_vars.popup_separator:"#ffffff";var branding=use_brand?"<a target='_blank' style='position:relative;bottom:3px' href='http://www.kampyle.com/feedback-form-registration?r=push'>Feedback Analytics by</a>"+" &nbsp;<a target='_blank' href='http://www.kampyle.com/feedback-form-registration?r=push_logo'><img src='"+k_push.images_dir+"logo.gif' /></a>"+"<div id='k_pop_whatisthis'><a href='http://www.kampyle.com/feedback-form-registration?r=push_wist&amp;sid="+k_push_vars.site_code+"' target='_blank' style='position: relative; bottom: -3px;'><img src='"+k_push.images_dir+"help.gif' style='vertical-align:bottom;' /></a><a href='http://www.kampyle.com/feedback-form-registration?r=push_wist&amp;sid="+k_push_vars.site_code+"' target='_blank' style='position: relative; bottom: -3px;left:-5px;'>What is this?</a></div>":""
popup.innerHTML=""+"<div id='k_popup_inner'>"+"<div id='k_pop_header' style='border-color: "+k_push.separator+"; direction:"+k_push.dir+"'>"+k_push.header+"</div>"+"<div id='k_pop_question_container' style='border-color:"+k_push.separator+"; direction:"+k_push.dir+"'>"+
k_push.question+"<div id='k_pop_yes_no'>"+"<a id='k_pop_yes_btn' style='background-color:"+k_push.yes_background+"; float: "+k_push.yes_float+";' onclick='document.getElementById(\""+k_push.ff_link_id+"\").rel = \"&amp;push=1\";document.getElementById(\""+k_push.ff_link_id+"\").onclick();k_push.closePopup(); return false;'>"+
k_push.yes+"</a>"+"<a id='k_pop_no_btn' style='background-color:"+k_push.no_background+"; float: "+k_push.no_float+";' onclick='k_push.closePopup(); return false;'>"+
k_push.no+"</a><br /><br />"+"<a id='k_pop_remind' onclick='k_push.remind_later()' style='color: "+k_push.remind_font_color+";'>"+
k_push.remind+"</a>"+"</div><br />"+
k_push.footer+"</div>"+"<div id='k_pop_branding'>"+branding+"</div>"+"</div>";popup.style.background=(k_push_vars.popup_background)?k_push_vars.popup_background:'#FFFFFF';popup.style.borderColor=k_push.separator;document.body.appendChild(popup);},"remind_later":function()
{k_push.closePopup();k_push.counter=0;timeForPopup=(new Date()).getTime()+parseInt(1000*60*2);var main_domain=k_button1.get_main_domain();k_button1.Set_Cookie("push_time_start",timeForPopup,0,"/",main_domain,'');k_button1.Set_Cookie("k_push8",0,0,"/",main_domain,'');},"openPopup":function()
{if(!k_push_vars.popup_manual)
{var timeNow=(new Date).getTime();var timeLeft=timeForPopup-timeNow;if(timeLeft>0)
return;if(k_button1.Get_Cookie('k_push8')&&k_button1.Get_Cookie('k_push8')!=0&&!k_push_vars.disable_cookie)
return;if((k_push.popup_open)||(k_push.counter>0)||(!document.getElementById(k_push.ff_link_id)))
return;}
var main_domain=k_button1.get_main_domain();var cookie_expiration_time_no=k_push_vars.cookie_expiration_time_no!=undefined?k_push_vars.cookie_expiration_time_no:k_push.cookie_expiration_time_no;k_button1.Set_Cookie('k_push8','1',cookie_expiration_time_no,'/',main_domain,'');k_push.counter++;k_push.popup_open=true;var maskBG=document.getElementById('k_maskBG')
var popup=document.getElementById('k_popup')
var scrollTop=document.documentElement.scrollTop||document.body.scrollTop;popup.style.top=(k_push.myHeight/2)-(k_push.popup_h/2)+scrollTop+'px';popup.style.left=k_push.myWidth/2-k_push.popup_w/2+'px';popup.style.display='block';var inner=document.getElementById("k_popup_inner");maskBG.innerHTML='<div style="width: 100%; height: 100%; opacity: 0.6; filter: alpha(opacity=60); background-color:#111111;"></div>';maskBG.style.position='absolute';maskBG.style.top='0px';maskBG.style.left='0px';maskBG.style.zIndex='998';var w=(document.documentElement.scrollWidth>document.body.scrollWidth)?document.documentElement.scrollWidth:document.body.scrollWidth;maskBG.style.width=w+'px';var h=(document.documentElement.scrollHeight>document.body.scrollHeight)?document.documentElement.scrollHeight:document.body.scrollHeight;maskBG.style.height=h+'px';maskBG.style.display='block';if(document.all)
k_push.toggleSelects('hidden');},"closePopup":function()
{var main_domain=k_button1.get_main_domain();k_button1.Set_Cookie("push_time_start","0",0,"/",main_domain,'');k_push.popup_open=false;var maskBG=document.getElementById('k_maskBG');var popup=document.getElementById('k_popup');popup.style.display='none';maskBG.style.display='none';if(document.all)
k_push.toggleSelects('visible');},"toggleSelects":function(visibility){try{var selects=document.getElementsByTagName('select');for(i=0;i<selects.length;i++)
selects[i].style.visibility=visibility;}
catch(err)
{}}};if(k_button1.Get_Cookie("push_time_start")>0)
{var timeForPopup=parseInt(k_button1.Get_Cookie("push_time_start"));}
else
{var seconds_to_delay=k_push_vars.display_after!=undefined?k_push_vars.display_after:k_push.after_time;var timeForPopup=(new Date()).getTime()+seconds_to_delay*1000;var main_domain=k_button1.get_main_domain();k_button1.Set_Cookie("push_time_start",timeForPopup,0,"/",main_domain,'');}
if(!k_push_vars.view_percentage)
k_push.n=0;else
k_push.n=(k_push_vars.view_percentage&&((k_push_vars.view_percentage>=0)&&(k_push_vars.view_percentage<=100)))?k_push_vars.view_percentage:10;var shouldLoad=false;if(k_push_vars.popup_manual)
{shouldLoad=true;}
else if(((k_push.n==null)||(((Math.random()*100)<k_push.n))))
{if(k_push_vars.disable_cookie)
shouldLoad=true;else if(!k_button1.Get_Cookie('k_push8')||k_button1.Get_Cookie('k_push8')==0)
shouldLoad=true;}
if(shouldLoad)
{if(window.addEventListener)
window.addEventListener('load',k_push.popup_init,false);else
window.attachEvent('onload',k_push.popup_init);}