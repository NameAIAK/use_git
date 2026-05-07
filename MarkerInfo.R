library(ggplot2)
packageVersion("ggplot2")
library(Seurat,lib.loc ="/nas2/zhangj/biosoft/miniconda3/envs/R4.4/lib/R/library",verbose=T)
packageVersion("Seurat")
library(SCP)
library(scCustomize)
library(qs)
library(tidydr)
library(tidyverse)
sp <-'mouse'

###### step4: 看标记基因库 ######
# 原则上分辨率是需要自己肉眼判断，取决于个人经验
sce.all.int <- qread("2-harmony/sce.all_harmony.qs")
sce.all.int
table(Idents(sce.all.int))
table(sce.all.int$RNA_snn_res.0.1)
table(sce.all.int$RNA_snn_res.0.3)
table(sce.all.int$RNA_snn_res.0.5)

getwd()
dir <-"3-check-by-0.3"
dir.create('3-check-by-0.3')
select_idet <-"RNA_snn_res.0.3"
sce.all.int$RNA_snn_res.0.3
# sce.all.int$RNA_snn_res.0.3 <- factor(sce.all.int$RNA_snn_res.0.3,levels = 0:15)
sce.all.int <- SetIdent(sce.all.int, value = select_idet)
table(sce.all.int@active.ident)
head(sce.all.int@meta.data)

p <- DimPlot(sce.all.int, reduction ="umap", group.by = select_idet, label = T) +
 ggtitle(select_idet)
p
p1 <- p +
 theme_dr(xlength = 0.2,ylength = 0.2) + # 应用带小箭头的坐标轴主题（来自tidydr包）
 theme(
  panel.grid = element_blank(),
  legend.text = element_text( size = 10, face ="plain",color ="black")
  )  # 去除所有网格线
p1
ggsave(plot=p1, filename=paste0(dir,"/Dimplot.pdf"),width = 6, height = 6)


# 美化版
p <- CellDimPlot(sce.all.int, group.by = select_idet, reduction ="UMAP", label = T,
        label.size = 4, label_repel = T, label_insitu = T,
        label_point_size = 1, label_point_color =NA ,label_segment_color = NA)
p
ggsave(plot=p, filename=paste0(dir,"/Dimplot.SCP.pdf"),width = 6, height = 6)


############################## 查看marker基因
# 一般基因
markers <- list(
"Immu"="PTPRC",
"Mast cells"=c("TPSAB1"),
"ILC"= c("KIT","KLRF1"),
"Cell Cycle"= c("TOP2A","MKI67"),
"Monocyte"= c("CD68","CD163","MARCO"),
"B cells"= c("CD79A","CD79B","CD19","MS4A1"),
"Plasma cells"= c("JCHAIN","IGKC"),
"platelets"= c("PF4","PPBP","GP9"),
"T cells"=c("CD3D","CD3E","CD3G"),
"CD4+ T cells"=c("CD4"),
"CD8+ T cells"=c("CD8A","CD8B"),
"NK"= c("NKG7","KLRG1","KLRC1"),
"DC"=c("CD1C","LAMP3")
)
if(sp=="mouse"){
 markers <- lapply(markers,function(x) str_to_title(x))
}
markers

p <- DotPlot(sce.all.int, features = markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(select_idet) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 60
p
ggsave(filename = paste0(dir,"/Markers_dotplot.pdf"), plot=p, width=12, height = 9,bg="white")



#####################################################################
#### paper 转移性胃癌基因 GSE163558
markers <- list(
"epithelial cells"= c("EPCAM","KRT19","CLDN4"),
"stromal cells"=c("PECAM1","COL1A2","VWF"),
"proliferative cells"= c("MKI67","STMN1","PCNA"),
"T cells"= c("CD3D","CD3E","CD2"),
"B cells"= c("CD79A","IGHG1","MS4A1"),
"NK cells"= c("KLRD1","GNLY","KLRF1"),
"myeloid cells"= c("CSF1R","CSF3R","CD68")
)
if(sp=="mouse"){
 markers <- lapply(markers,function(x) str_to_title(x))
}
markers

p <- DotPlot(sce.all.int, features = markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE163558")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 60
p
ggsave(filename = paste0(dir,"/Markers_paperGSE163558_dotplot.pdf"), plot=p, width=12, height = 9,bg="white")



#####################################################################
##### 具有配对的肿瘤和正常样本的胃癌marker基因 GSE206785
# 创建一个空的list对象
cell_markers <- list()
# 添加每种细胞类型的marker基因
cell_markers$B_cells<- c("CD19","MS4A1")
cell_markers$plasma_cells<- c("IGHG1","CD79A")
cell_markers$CD4_T_cells<- c("CD3D","CD4")
cell_markers$CD8_T_cells<- c("CD8A")
cell_markers$NK_cells<- c("NCR1","FGFBP2")
cell_markers$myeloid_cells<- c("CD14","CD68")
cell_markers$mast_cells<- c("TPSAB1","TPSB2")
cell_markers$endothelial_cells<- c("RAMP2","PECAM1")
cell_markers$fibroblasts<- c("DCN","LUM")
cell_markers$mural_cells<- c("PDGFRB","ACTA2")
cell_markers$glial_cells<- c("PLP1","SOX10")
cell_markers$epithelial_cells<- c("PGC","PGA3")
# 打印list对象
if(sp=="mouse"){
 cell_markers <- lapply(cell_markers,function(x) str_to_title(x))
}
print(cell_markers)

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE206785")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 60
p
ggsave(filename = paste0(dir,"/Markers_paperGSE206785_dotplot.pdf"), plot=p, width=12, height = 9,bg="white")


#############################################################
# 特发性肺纤维化病：https://pmc.ncbi.nlm.nih.gov/articles/PMC8025672/#SD3
# GSE128033: 8个特发性纤维化（IPF）样本和10个正常样本，共66500个细胞
# 创建一个列表，包含不同细胞类型的marker基因
cell_markers <- list(
"Club cells"="SCGB1A1",
"Alveolar type I cells (AT1)"="AGER",
"Alveolar type II cells (AT2)"="SFTPC",
"Ciliated cells"="FOXJ1",
"Basal airway cells"="KRT5",
"Goblet cells"="MUC5B",
"Fibroblasts"= c("COL1A1"),
"Smooth muscle cells"="DES",
"Endothelial cells"="VWF",
"Lymphatic endothelial cells"="LYVE1",
"Pericytes"="RGS5",
"Macrophages"= c("AIF1","CD163"),
"Dendritic cells"="CD1C",
"Mast cells"="TPSAB1",
"T lymphocytes"= c("CD3D","CD3E","CD3G","CD8A"),
"B lymphocytes"= c("MS4A1","IGKC","MZB1"),
"NK cells"="GNLY"
)
if(sp=="mouse"){
 cell_markers <- lapply(cell_markers,function(x) str_to_title(x))
}
# 打印列表查看结果
print(cell_markers)

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE128033")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_paperGSE128033_dotplot.pdf"), plot=p, width=12, height = 8,bg="white")


## 上面是正常肺，下面是两种都有
cell_markers <- list(
"Club cells"= c("SCGB1A1","SCGB3A2"),
"Alveolar type I (AT1) cells"="AGER",
"Goblet cells"="MUC5B",
"Alveolar type II (AT2) cells"="SFTPC",
"Ciliated cells"="FOXJ1",
"Basal airway cells"="KRT5",
"Fibroblasts"= c("COL1A1","COL1A2","PDGFRA"),
"Smooth muscle cells"= c("DES","ACTG2"),
"Endothelial cells"="VWF",
"Pericytes"="RGS5",
"Lymphatic endothelial cells"="LYVE1",
"Macrophages"= c("AIF1","CD163"),
"Dendritic cells"="CD1C",
"T lymphocytes"= c("CD3D","CD8A"),
"B lymphocytes"= c("CD79A","MS4A1","IGKC","IGHA1","IGHG3","MZB1"),
"NK cells"= c("GNLY","NKG7","GZMB","PRF1","CST7"),
"ILC1/NK cells"= c("CCL3","CCL4","CCL5"),
"Mast cells"= c("TPSAB1","CPA3","MS4A2")
)
if(sp=="mouse"){
 cell_markers <- lapply(cell_markers,function(x) str_to_title(x))
}
# 打印列表查看结果
print(cell_markers)

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE128033-1")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_paperGSE128033_dotplot-1.pdf"), plot=p, width=15, height = 8,bg="white")



###########################################
## 中心粒细胞
myeloids = list(
 Mac=c("C1QA","C1QB","C1QC","SELENOP","RNASE1","DAB2","LGMN","PLTP","MAF","SLCO2B1"),
 mono=c("VCAN","FCN1","CD300E","S100A12","EREG","APOBEC3A","STXBP2","ASGR1","CCR2","NRG1"),
 neutrophils = c("FCGR3B","CXCR2","SLC25A37","G0S2","CXCR1","ADGRG3","PROK2","STEAP4","CMTM2"),
 pDC = c("GZMB","SCT","CLIC3","LRRC26","LILRA4","PACSIN1","CLEC4C","MAP1A","PTCRA","C12orf75"),
 DC1 = c("CLEC9A","XCR1","CLNK","CADM1","ENPP1","SNX22","NCALD","DBN1","HLA-DOB","PPY"),
 DC2=c("CD1C","FCER1A","CD1E","AL138899.1","CD2","GPAT3","CCND2","ENHO","PKIB","CD1B"),
 DC3 = c("HMSD","ANKRD33B","LAD1","CCR7","LAMP3","CCL19","CCL22","INSM1","TNNT2","TUBB2B")
)
if(sp=="mouse"){
 myeloids <- lapply(myeloids,function(x) str_to_title(x))
}
print(myeloids)

p <- DotPlot(sce.all.int, features = myeloids, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": myeloids")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_myeloids_dotplot.pdf"), plot=p, width=15, height = 8,bg="white")



################################ 数据marker：OMIX004421
cell_types <- list(
 TECs = c("Lrp2"),
 LOH = c("Slc12a1"),
 DT = c("Slc12a3"),
 IC_PC = c("Aqp2","Atp6v1g3"),
 MES = c("Pdgfrb"),
 ENDO = c("Emcn"),
 T = c("Cd3d"),
 B = c("Cd79a"),
 Meloid = c("Cd68")
)
if(sp!="mouse"){
 cell_types <- lapply(cell_types,function(x) str_to_upper(x))
}
print(cell_types)

p <- DotPlot(sce.all.int, features = cell_types, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": OMIX004421")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_OMIX004421_dotplot.pdf"), plot=p, width=15, height = 8,bg="white")



####################################################################
## 数据集 GSE289708
cell_markers <- list(
 GP = c("Elane","Prss57","Prtn3","Mpo","Rgcc","Nkg7","Ctsg","Etfb","Srgn"),
 GMP = c("Gas5","Adgrg1","Pebp1","Eef1g","Mef2c","Ctla2a","Nrgn","Myb","Cd34","Ms4a3","Irf8","Lgals1","Ass1","Calr","Ramp1","Gria3","Mif","Ran","Gstm1"),
 immature_neu = c("Wfdc21","Ltf","Ly6g","Cd177","Fpr2","Lrg1","Syne1","Pglyrp1"),
 Ly6Chi_mono = c("S100a4","Fn1","Ccr2","F13a1","Wfdc17","Mpeg1","Ahnak"),
 mature_neu = c("Retnlg","Cxcr2","Mmp9","Slpi","Mmp8","Mxd1","Ccr1","Cd33","Csf3r"),
 MEP = c("Car1","Car2","Gstm5","Blvrb","Sdsl","Tspo2","Aqp1","Ncl"),
 Ly6Clow_mono = c("Gngt2","Apoe","Pou2f2","Clec4a3","Cx3cr1","Ctss","Adgre4","Ear2","Apoc2","Eno3"),
 cMoP = c("Ifi30","Ms4a6c","S100a10","Crip1","Ctsc","Npc2","Prdx1","Ly6e","Anxa5","Prdx4"),
 pre_neu = c("Orm1","St3gal5","Adpgk","Chil1","Cebpe","Zmpste24","Tmem216"),
 pre_neu_cycling = c("Ube2c","Fcnb","Cenpf","Tuba4a","Mki67","Serpinb1a")
)
if(sp!="mouse"){
 cell_markers <- lapply(cell_markers,function(x) str_to_upper(x))
}
cell_markers

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE289708")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_GSE289708_dotplot.pdf"), plot=p, width=15, height = 8,bg="white")


####################################################################
## 脑膜瘤数据集 HRA004857
cell_markers <- list(
"neoplastic cells"= c("CLU","PTN","LEPR","SSTR2"),
"macrophages"= c("HLA-DRB5","CD74","MS4A6A","LYZ"),
"T cells"= c("CD3D","CD3E","CD3G","CD52"),
"endothelial cells"= c("CD34","VWF","CCL14","PLVAP"),
"fibroblasts"= c("ACTA2","RGS5"),
"oligodendrocytes"= c("CNP","MAG","KLK6","OLIG2")
)
if(sp=="mouse"){
 cell_markers <- lapply(cell_markers,function(x) str_to_title(x))
}
cell_markers

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": HRA004857")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_HRA004857_dotplot.pdf"), plot=p, width=15, height = 8,bg="white")


####################################################################
## 皮肤组织银屑病数据集 GSE173706
cell_markers <- list(
 keratinocytes = c("KRT14","KRT1","DMKN"),
 melanocytes = c("DCT","TYRP1","PMEL"),
 eccrine_gland_cells = c("PIP","DCD","MUCL1"),
 endothelial_cells = c("PECAM1","CDH5","CLDN5"),
 fibroblasts = c("DCN","COL1A1","COL1A2"),
 smooth_muscle_cells = c("ACTA2","TAGLN","MYL9"),
 nerve_cells = c("MPZ","PLP1","S100B"),
 t_cells = c("CD3D","CD3E","TRAC"),
 myeloid_cells = c("CD74","HLA-DRA","HLA-DPB1"),
 mast_cells = c("CPA3","TPSAB1","CTSG")
)
if(sp=="mouse"){
 cell_markers <- lapply(cell_markers,function(x) str_to_title(x))
}
cell_markers

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE173706")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_GSE173706_dotplot.pdf"), plot=p, width=15, height = 8,bg="white")


################################ 数据集合 CRA007721----
# 小鼠脑
cell_markers <- list(
 neuron = c("Sox11"),
 oligodendrocyte = c("Mbp"),
 astrocyte = c("Aldoc"),
 endothelial = c("Cldn5"),
 mural_cell = c("Kcnj8"),
 RBC = c("Hba-a1"),
 fibroblast = c("Dcn"),
 arachnoid_barrier_cell = c("Slc47a1"),
 ependymocyte = c("Ccdc153"),
 choroid_plexus = c("Ttr"),
 monocyte = c("Plac8"),
 microglia = c("Aif1"),
 macrophage = c("Pf4"),
 neutrophil = c("S100a9"),
 T_NK_cell = c("Cd3e"),
 B = c("Cd79a")
)

# if(sp=="mouse"){
#  cell_markers <- lapply(cell_markers, function(x) str_to_title(x))
# }
cell_markers

p <- DotPlot(sce.all.int, features = cell_markers, assay='RNA',group.by = select_idet,cols = c("grey","red") ) +
 ggtitle(paste0(select_idet,": GSE173706")) +
 xlab("") +
 theme(axis.text.x = element_text(angle = 45, hjust = 1)) # 更改x轴标签角度
p[["theme"]][["strip.text"]]$angle<- 90
p[["theme"]][["strip.text"]]$hjust<- 0
p
ggsave(filename = paste0(dir,"/Markers_CRA007721_dotplot.pdf"), plot=p, width=15, height = 10,bg="white")

# 查看每个样本中的细胞分类数据
gplots::balloonplot(table(sce.all.int$RNA_snn_res.0.3,sce.all.int$orig.ident))
gplots::balloonplot(table(sce.all.int$RNA_snn_res.0.1,sce.all.int$orig.ident))


################## 注释，读取注释文件
sce.all.int
head(sce.all.int@meta.data)
Idents(sce.all.int) <-"RNA_snn_res.0.3"
Idents(sce.all.int)

temp <- read.table("3-check-by-0.3/anno.txt",sep ="\t")
temp

new.cluster.ids <- temp[,2]
names(new.cluster.ids) <- temp[,1]
new.cluster.ids

sce.all.int <- RenameIdents(sce.all.int, new.cluster.ids)
table(Idents(sce.all.int))

## 新增一列注释
anno <- as.data.frame(sce.all.int@active.ident)
sce.all.int <- AddMetaData(sce.all.int, metadata = anno, col.name ="celltype")
head(sce.all.int@meta.data)
table(sce.all.int$celltype)

# 美化版
p <- CellDimPlot(sce.all.int, group.by ="celltype", reduction ="UMAP", label = T,label.size = 3, label_repel = T, label_insitu = T,
        label_point_size = 1, label_point_color =NA ,label_segment_color = NA)
p
ggsave(plot=p, filename="3-check-by-0.3/Dimplot_celltype.pdf",width = 8, height = 8)

phe <- sce.all.int@meta.data
head(phe)
saveRDS(phe, file ="3-check-by-0.3/phe.rds")