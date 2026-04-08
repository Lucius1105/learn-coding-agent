const PptxGenJS = require("pptxgenjs");
const pptx = new PptxGenJS();

// VI规范配色
const COLORS = {
  wisdomBlue: "060E9F",
  harvestGold: "FFB547",
  darkGrey: "414042",
  airWhite: "FFFFFF",
  calmBlue: "0D1A63"
};

pptx.layout = "16x9";
pptx.author = "雨后甘霖";
pptx.title = "中小企业的灵魂三问";

const FONT = "OPPO Sans";

// ========== 第1页：流程介绍 ==========
let s1 = pptx.addSlide();
s1.background = { color: COLORS.airWhite };
s1.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: "100%", h: 0.15, fill: { color: COLORS.wisdomBlue } });
s1.addText("中小企业的灵魂三问", { x: 0.5, y: 1.2, w: "90%", h: 0.8, fontSize: 44, fontFace: FONT, bold: true, color: COLORS.wisdomBlue, align: "center" });
s1.addText("使命 · 愿景 · 价值观", { x: 0.5, y: 2.0, w: "90%", h: 0.5, fontSize: 24, fontFace: FONT, color: COLORS.darkGrey, align: "center" });
s1.addText("即兴演讲环节流程", { x: 0.5, y: 3.0, w: "90%", h: 0.4, fontSize: 18, fontFace: FONT, bold: true, color: COLORS.wisdomBlue, align: "center" });

const items = [{t:"2'",d:"开场引言"},{t:"6'",d:"使命篇·3位"},{t:"6'",d:"愿景篇·3位"},{t:"6'",d:"价值观篇·3位"},{t:"2'",d:"总结收尾"}];
items.forEach((it,i)=>{
  const x=0.8+i*2.2;
  s1.addShape(pptx.ShapeType.ellipse,{x:x,y:3.8,w:0.5,h:0.5,fill:{color:i===0||i===4?COLORS.harvestGold:COLORS.wisdomBlue}});
  s1.addText(it.t,{x:x,y:3.9,w:0.5,h:0.3,fontSize:12,fontFace:FONT,bold:true,color:COLORS.airWhite,align:"center"});
  s1.addText(it.d,{x:x-0.3,y:4.5,w:1.1,h:0.4,fontSize:14,fontFace:FONT,color:COLORS.darkGrey,align:"center"});
  if(i<4) s1.addShape(pptx.ShapeType.line,{x:x+0.5,y:4.05,w:1.7,h:0,line:{color:COLORS.wisdomBlue,width:2}});
});
s1.addText("即兴主持：徐沛霖 | 商业教练", { x: 0.5, y: 5.5, w: "90%", h: 0.4, fontSize: 14, fontFace: FONT, color: COLORS.darkGrey, align: "center" });

// ========== 第2页：前言 ==========
let s2 = pptx.addSlide();
s2.background = { color: COLORS.calmBlue };
s2.addText(""", { x: 0.3, y: 0.5, w: 0.5, h: 1, fontSize: 120, fontFace: FONT, color: COLORS.harvestGold });
s2.addText("有力的发问", { x: 1.0, y: 1.0, w: "80%", h: 0.8, fontSize: 40, fontFace: FONT, bold: true, color: COLORS.airWhite });
const intro = `我是徐沛霖，做商业教练。

过去服务过不少老板，发现一个现象——
很多人把使命、愿景、价值观当成"装修"，
贴墙上好看，但不知道怎么用。

今晚我想试试，用"有力的发问"这个工具，
带大家摸摸自己企业的"骨头"。

不是问"你怎么想的"，
是问一些让你停下来、重新看自己的问题。`;
s2.addText(intro, { x: 1.0, y: 2.0, w: "80%", h: 3.5, fontSize: 18, fontFace: FONT, color: COLORS.airWhite, lineSpacing: 32 });
s2.addShape(pptx.ShapeType.rect, { x: 0, y: 6.5, w: "100%", h: 0.1, fill: { color: COLORS.harvestGold } });

// ========== 第3页：总议题 ==========
let s3 = pptx.addSlide();
s3.background = { color: COLORS.airWhite };
s3.addText("灵魂三问", { x: 0.5, y: 0.5, w: "90%", h: 0.6, fontSize: 36, fontFace: FONT, bold: true, color: COLORS.wisdomBlue, align: "center" });

const rows = [
  {y:1.5,c:COLORS.wisdomBlue,t:"使命",d:"你为什么存在"},
  {y:3.0,c:COLORS.calmBlue,t:"愿景",d:"你要去向何方"},
  {y:4.5,c:COLORS.wisdomBlue,t:"价值观",d:"你坚持什么"}
];
rows.forEach(r=>{
  s3.addShape(pptx.ShapeType.rect,{x:0.5,y:r.y,w:2.5,h:1.2,fill:{color:r.c}});
  s3.addText(r.t,{x:0.5,y:r.y+0.25,w:2.5,h:0.7,fontSize:28,fontFace:FONT,bold:true,color:COLORS.airWhite,align:"center"});
  s3.addText(r.d,{x:3.2,y:r.y,w:6,h:1.2,fontSize:20,fontFace:FONT,color:COLORS.darkGrey,valign:"middle"});
});
s3.addText("9个问题 · 9位朋友 · 0个标准答案", { x: 0.5, y: 6.0, w: "90%", h: 0.4, fontSize: 16, fontFace: FONT, color: COLORS.harvestGold, align: "center" });

// ========== 第4页：使命篇标题 ==========
let s4 = pptx.addSlide();
s4.background = { color: COLORS.wisdomBlue };
s4.addText("第一轮", { x: 0.5, y: 2.0, w: "90%", h: 0.6, fontSize: 24, fontFace: FONT, color: COLORS.harvestGold, align: "center" });
s4.addText("使命", { x: 0.5, y: 2.8, w: "90%", h: 1.0, fontSize: 60, fontFace: FONT, bold: true, color: COLORS.airWhite, align: "center" });
s4.addText("你为什么存在", { x: 0.5, y: 4.0, w: "90%", h: 0.5, fontSize: 28, fontFace: FONT, color: COLORS.airWhite, align: "center" });

// ========== 第5页：使命篇关键词 ==========
let s5 = pptx.addSlide();
s5.background = { color: COLORS.airWhite };
s5.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: "100%", h: 0.08, fill: { color: COLORS.wisdomBlue } });
s5.addText("使命篇", { x: 0.5, y: 0.15, w: "90%", h: 0.4, fontSize: 14, fontFace: FONT, color: COLORS.wisdomBlue });

const mKeys = [
  {t:"第一个客户",d:"想想你创业后，第一个真正付钱给你的人。他为什么选你？"},
  {t:"最骄傲的时刻",d:"做企业这么久，哪一刻你真的觉得自己'这事成了'？"},
  {t:"如果重来",d:"如果让你重新选，你还会做这行吗？"}
];
mKeys.forEach((k,i)=>{
  const y=1.0+i*1.8;
  s5.addShape(pptx.ShapeType.rect,{x:0.5,y:y,w:9,h:1.5,fill:{color:i===1?"F5F5F5":COLORS.airWhite},line:{color:COLORS.wisdomBlue,width:1}});
  s5.addShape(pptx.ShapeType.ellipse,{x:0.8,y:y+0.4,w:0.6,h:0.6,fill:{color:COLORS.wisdomBlue}});
  s5.addText(String(i+1),{x:0.8,y:y+0.5,w:0.6,h:0.4,fontSize:20,fontFace:FONT,bold:true,color:COLORS.airWhite,align:"center"});
  s5.addText(k.t,{x:1.8,y:y+0.2,w:7.5,h:0.5,fontSize:22,fontFace:FONT,bold:true,color:COLORS.wisdomBlue});
  s5.addText(k.d,{x:1.8,y:y+0.7,w:7.5,h:0.6,fontSize:14,fontFace:FONT,color:COLORS.darkGrey});
});

// ========== 第6页：愿景篇标题 ==========
let s6 = pptx.addSlide();
s6.background = { color: COLORS.calmBlue };
s6.addText("第二轮", { x: 0.5, y: 2.0, w: "90%", h: 0.6, fontSize: 24, fontFace: FONT, color: COLORS.harvestGold, align: "center" });
s6.addText("愿景", { x: 0.5, y: 2.8, w: "90%", h: 1.0, fontSize: 60, fontFace: FONT, bold: true, color: COLORS.airWhite, align: "center" });
s6.addText("你要去向何方", { x: 0.5, y: 4.0, w: "90%", h: 0.5, fontSize: 28, fontFace: FONT, color: COLORS.airWhite, align: "center" });

// ========== 第7页：愿景篇关键词 ==========
let s7 = pptx.addSlide();
s7.background = { color: COLORS.airWhite };
s7.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: "100%", h: 0.08, fill: { color: COLORS.calmBlue } });
s7.addText("愿景篇", { x: 0.5, y: 0.15, w: "90%", h: 0.4, fontSize: 14, fontFace: FONT, color: COLORS.calmBlue });

const vKeys = [
  {t:"三年后的画面",d:"闭上眼睛，三年后的某个上午，你在干什么？"},
  {t:"别人眼中的你",d:"你的客户/员工，会用哪三个词形容你？"},
  {t:"想留下的东西",d:"如果明天不干了，你想给这个行业留下什么？"}
];
vKeys.forEach((k,i)=>{
  const y=1.0+i*1.8;
  s7.addShape(pptx.ShapeType.rect,{x:0.5,y:y,w:9,h:1.5,fill:{color:i===1?"F5F5F5":COLORS.airWhite},line:{color:COLORS.calmBlue,width:1}});
  s7.addShape(pptx.ShapeType.ellipse,{x:0.8,y:y+0.4,w:0.6,h:0.6,fill:{color:COLORS.calmBlue}});
  s7.addText(String(i+1),{x:0.8,y:y+0.5,w:0.6,h:0.4,fontSize:20,fontFace:FONT,bold:true,color:COLORS.airWhite,align:"center"});
  s7.addText(k.t,{x:1.8,y:y+0.2,w:7.5,h:0.5,fontSize:22,fontFace:FONT,bold:true,color:COLORS.calmBlue});
  s7.addText(k.d,{x:1.8,y:y+0.7,w:7.5,h:0.6,fontSize:14,fontFace:FONT,color:COLORS.darkGrey});
});

// ========== 第8页：价值观篇标题 ==========
let s8 = pptx.addSlide();
s8.background = { color: COLORS.wisdomBlue };
s8.addText("第三轮", { x: 0.5, y: 2.0, w: "90%", h: 0.6, fontSize: 24, fontFace: FONT, color: COLORS.harvestGold, align: "center" });
s8.addText("价值观", { x: 0.5, y: 2.8, w: "90%", h: 1.0, fontSize: 60, fontFace: FONT, bold: true, color: COLORS.airWhite, align: "center" });
s8.addText("你坚持什么", { x: 0.5, y: 4.0, w: "90%", h: 0.5, fontSize: 28, fontFace: FONT, color: COLORS.airWhite, align: "center" });

// ========== 第9页：价值观篇关键词 ==========
let s9 = pptx.addSlide();
s9.background = { color: COLORS.airWhite };
s9.addShape(pptx.ShapeType.rect, { x: 0, y: 0, w: "100%", h: 0.08, fill: { color: COLORS.wisdomBlue } });
s9.addText("价值观篇", { x: 0.5, y: 0.15, w: "90%", h: 0.4, fontSize: 14, fontFace: FONT, color: COLORS.wisdomBlue });

const valKeys = [
  {t:"绝不妥协",d:"有什么事，哪怕亏钱你也不会做？"},
  {t:"团队最像你的地方",d:"你的团队里，哪一点最像你？"},
  {t:"给新人的一句话",d:"如果新加入的员工只能记住你一句话，是什么？"}
];
valKeys.forEach((k,i)=>{
  const y=1.0+i*1.8;
  s9.addShape(pptx.ShapeType.rect,{x:0.5,y:y,w:9,h:1.5,fill:{color:i===1?"F5F5F5":COLORS.airWhite},line:{color: