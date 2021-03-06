## ----setup-options, echo = FALSE, results = "hide", message = FALSE-----------
options(htmltools.dir.version = FALSE)
knitr::opts_chunk$set(cache = TRUE, dev = 'svg', echo = TRUE, message = FALSE, warning = FALSE,
                      fig.height=6, fig.width = 1.777777*6)
library("vegan")
library("ggplot2")
data(varespec)
data(varechem)

## plot defaults
theme_set(theme_minimal(base_size = 16, base_family = 'Fira Sans'))


## ----cca-model----------------------------------------------------------------
cca1 <- cca(varespec ~ ., data = varechem)
cca1


## ----rda-model----------------------------------------------------------------
rda1 <- rda(varespec ~ ., data = varechem)
rda1


## ----eigenvals----------------------------------------------------------------
eigenvals(cca1)


## ----your-turn-fit-cca-1------------------------------------------------------
library("vegan")
data(varechem, varespec)


## ----your-turn-fit-cca-2------------------------------------------------------
mycca1 <- cca(varespec ~ N + P + K, data = varechem)
mycca1


## ----your-turn-fit-cca-3------------------------------------------------------
ev <- eigenvals(mycca1, model = "constrained")
head(ev)
length(ev)


## ----scores-------------------------------------------------------------------
str(scores(cca1, choices = 1:4, display = c("species","sites")), max = 1)
head(scores(cca1, choices = 1:2, display = "sites"))


## ----scaling-example, results = "hide"----------------------------------------
scores(cca1, choices = 1:2, display = "species", scaling = 3)


## ----your-turn-cca-4----------------------------------------------------------
scrs <- scores(mycca1, display = "sites", choices = c(2,3),
               scaling = "sites", hill = TRUE)
head(scrs)


## ----partial-ordination-1-----------------------------------------------------
pcca <- cca(X = varespec,
            Y = varechem[, "Ca", drop = FALSE],
            Z = varechem[, "pH", drop = FALSE])


## ----partial-ordination-2-----------------------------------------------------
pcca <- cca(varespec ~ Ca + Condition(pH), data = varechem) ## easier!


## ----partial-ordination-3-----------------------------------------------------
pcca <- cca(varespec ~ Ca + Condition(pH), data = varechem) ## easier!
pcca


## ----triplot-1, fig.height = 6, fig.width = 6---------------------------------
plot(cca1)


## ----cca-model-build1---------------------------------------------------------
vare.cca <- cca(varespec ~ Al + P*(K + Baresoil), data = varechem)
vare.cca


## ----vif-cca1-----------------------------------------------------------------
vif.cca(cca1)


## ----stepwise-1---------------------------------------------------------------
upr <- cca(varespec ~ ., data = varechem)
lwr <- cca(varespec ~ 1, data = varechem)
set.seed(1)
mods <- ordistep(lwr, scope = formula(upr), trace = 0)


## ----stepwise-cca-------------------------------------------------------------
mods


## ----stepwise-anova-----------------------------------------------------------
mods$anova


## ----stepwise-reverse, results = "hide"---------------------------------------
mods2 <- step(upr, scope = list(lower = formula(lwr), upper = formula(upr)), trace = 0,
              test = "perm")
mods2


## ----stepwise-reverse---------------------------------------------------------
mods2 <- step(upr, scope = list(lower = formula(lwr), upper = formula(upr)), trace = 0,
              test = "perm")
mods2


## ----rsq-cca1-----------------------------------------------------------------
RsquareAdj(cca1)


## ----stopping-rules-----------------------------------------------------------
ordiR2step(lwr, upr, trace = FALSE)


## ----permustats-1, results = "hide"-------------------------------------------
pstat <- permustats(anova(cca1))
summary(pstat)


## ----permustats-1, echo = FALSE-----------------------------------------------
pstat <- permustats(anova(cca1))
summary(pstat)


## ----permustats-2, fig.width = 6, fig.height = 6------------------------------
densityplot(pstat)


## ----cca-anova----------------------------------------------------------------
set.seed(42)
(perm <- anova(cca1))


## ----anova-args---------------------------------------------------------------
args(anova.cca)


## ----anova-by-axis------------------------------------------------------------
set.seed(1)
anova(mods, by = "axis")


## ----anova-by-term------------------------------------------------------------
set.seed(5)
anova(mods, by = "terms")


## ----anova-by-margin----------------------------------------------------------
set.seed(10)
anova(mods, by = "margin")


## ----meadows-setup------------------------------------------------------------
## load vegan
library("vegan")

## load the data
spp <- read.csv("data/meadow-spp.csv", header = TRUE, row.names = 1)
env <- read.csv("data/meadow-env.csv", header = TRUE, row.names = 1)


## ----meadows-cca-full---------------------------------------------------------
m1 <- cca(spp ~ ., data = env)
set.seed(32)
anova(m1)


## ----meadows-cca-full-triplot, fig.show = "hide"------------------------------
plot(m1)


## ----meadows-cca-full-triplot, fig.height = 6, fig.width = 6, echo = FALSE----
plot(m1)


## ----meadows-cca-stepwise-----------------------------------------------------
set.seed(67)
lwr <- cca(spp ~ 1, data = env)
( m2 <- ordistep(lwr, scope = formula(m1), trace = FALSE) )


## ----meadows-cca-reduced-triplot, fig.show = "hide"---------------------------
plot(m2)


## ----meadows-cca-reduced-triplot, fig.height = 6, fig.width = 6, echo = FALSE----
plot(m2)


## ----meadows-cca-anova--------------------------------------------------------
m2$anova


## ----meadows-rda--------------------------------------------------------------
spph <- decostand(spp, method = "hellinger")
m3 <- rda(spph ~ ., data = env)
lwr <- rda(spph ~ 1, data = env)
m4 <- ordistep(lwr, scope = formula(m3),
               trace = FALSE)


## ----meadows-rda-print--------------------------------------------------------
m4


## ----meadows-rda-reduced-triplot, fig.show = "hide"---------------------------
plot(m4)


## ----meadows-rda-reduced-triplot, fig.height = 6, fig.width = 6, echo = FALSE----
plot(m4)


## ----meadows-rda-adjrsquare---------------------------------------------------
m5 <- ordiR2step(lwr, scope = formula(m3), trace = FALSE)
m5$anova


## ----cyclic-shift-figure, echo = FALSE----------------------------------------
knitr::include_graphics("./resources/cyclic-shifts-figure.png")


## ----shuffle-time-series, echo = TRUE-----------------------------------------
shuffle(10, control = how(within = Within(type = "series")))


## ----set-up-toroidal----------------------------------------------------------
set.seed(4)
h <- how(within = Within(type = "grid",
                         ncol = 3, nrow = 3))
perm <- shuffle(9, control = h)
matrix(perm, ncol = 3)


## ----toroidal-shifts-figure, echo = FALSE-------------------------------------
knitr::include_graphics("./resources/Toroidal_coord.png")


## ----cyclic-shift-mirror-figure, echo = FALSE---------------------------------
knitr::include_graphics("./resources/cyclic-shifts-with-mirror-figure.svg")


## -----------------------------------------------------------------------------
plt <- gl(3, 10)
h <- how(within = Within(type = "series"), plots = Plots(strata = plt))


## ----helper-funs--------------------------------------------------------------
args(Within)
args(Plots)


## ----how-args-----------------------------------------------------------------
args(how)


## ----ts-perm-example1---------------------------------------------------------
plt <- gl(3, 10)
h <- how(within = Within(type = "series"),
         plots = Plots(strata = plt))
set.seed(4)
p <- shuffle(30, control = h)
do.call("rbind", split(p, plt)) ## look at perms in context


## ----ts-perm-example2---------------------------------------------------------
plt <- gl(3, 10)
h <- how(within = Within(type = "series", constant = TRUE),
         plots = Plots(strata = plt))
set.seed(4)
p <- shuffle(30, control = h)
do.call("rbind", split(p, plt)) ## look at perms in context


## ----worked-example-devel-1---------------------------------------------------
## load vegan
library("vegan")

## load the data
spp <- read.csv("data/ohraz-spp.csv", header = TRUE, row.names = 1)
env <- read.csv("data/ohraz-env.csv", header = TRUE, row.names = 1)
molinia <- spp[, 1]
spp <- spp[, -1]

## Year as numeric
env <- transform(env, year = as.numeric(as.character(year)))


## ----worked-example-devel-2---------------------------------------------------
c1 <- rda(spp ~ year + year:mowing + year:fertilizer + year:removal + Condition(plotid), data = env)
(h <- how(within = Within(type = "none"), plots = Plots(strata = env$plotid, type = "free")))


## ----worked-example-devel-2a--------------------------------------------------
set.seed(42)
anova(c1, permutations = h, model = "reduced")


## ----worked-example-devel-2b--------------------------------------------------
set.seed(24)
anova(c1, permutations = h, model = "reduced", by = "axis")


## ----load-crayfish------------------------------------------------------------
## load data
crayfish <- head(read.csv("data/crayfish-spp.csv")[, -1], -1)
design <- read.csv("data/crayfish-design.csv", skip = 1)[, -1]

## fixup the names
names(crayfish) <- gsub("\\.", "", names(crayfish))
names(design) <- c("Watershed", "Stream", "Reach", "Run",
                   "Stream.Nested", "ReachNested", "Run.Nested")


## ----crayfish-unconstrained---------------------------------------------------
m.pca <- rda(crayfish)
summary(eigenvals(m.pca))


## ----crayfish-pca-plot, fig.show = "hide", collapse = TRUE--------------------
layout(matrix(1:2, ncol = 2))
biplot(m.pca, type = c("text", "points"), scaling = "species")
set.seed(23)
ev.pca <- envfit(m.pca ~ Watershed, data = design, scaling = "species")
plot(ev.pca, labels = levels(design$Watershed), add = FALSE)
layout(1)


## ----crayfish-pca-plot, fig.show = "hold", out.width = "75%", echo = FALSE, fig.height = 5----
layout(matrix(1:2, ncol = 2))
biplot(m.pca, type = c("text", "points"), scaling = "species")
set.seed(23)
ev.pca <- envfit(m.pca ~ Watershed, data = design, scaling = "species")
plot(ev.pca, labels = levels(design$Watershed), add = FALSE)
layout(1)


## ----crayfish-watershed-------------------------------------------------------
m.ws <- rda(crayfish ~ Watershed, data = design)
m.ws


## ----crayfish-watershed-2-----------------------------------------------------
summary(eigenvals(m.ws, constrained = TRUE))


## ----crayfish-watershed-3-----------------------------------------------------
set.seed(1)
ctrl <- how(nperm = 499, within = Within(type = "none"),
            plots = with(design, Plots(strata = Stream, type = "free")))
(sig.ws <- anova(m.ws, permutations = ctrl))


## ----crayfish-stream----------------------------------------------------------
m.str <- rda(crayfish ~ Stream + Condition(Watershed), data = design)
m.str


## ----crayfish-stream-2--------------------------------------------------------
summary(eigenvals(m.str, constrained = TRUE))


## ----crayfish-stream-3--------------------------------------------------------
set.seed(1)
ctrl <- how(nperm = 499, within = Within(type = "none"),
            plots = with(design, Plots(strata = Reach, type = "free")),
            blocks = with(design, Watershed))
(sig.str <- anova(m.str, permutations = ctrl))


## ----crayfish-reach-----------------------------------------------------------
(m.re <- rda(crayfish ~ Reach + Condition(Stream), data = design))


## ----crayfish-reach-2---------------------------------------------------------
set.seed(1)
ctrl <- how(nperm = 499, within = Within(type = "none"),
            plots = with(design, Plots(strata = Run, type = "free")),
            blocks = with(design, Stream))
(sig.re <- anova(m.re, permutations = ctrl))


## ----crayfish-run-------------------------------------------------------------
(m.run <- rda(crayfish ~ Run + Condition(Reach), data = design))


## ----crayfish-run-2-----------------------------------------------------------
set.seed(1)
ctrl <- how(nperm = 499, within = Within(type = "free"),
            blocks = with(design, Reach))
(sig.run <- anova(m.run, permutations = ctrl))


## ----permanova-idea-plot, echo = FALSE----------------------------------------
data(varespec)
     
## Bray-Curtis distances between samples
dis <- vegdist(varespec)
     
## First 16 sites grazed, remaining 8 sites ungrazed
groups <- factor(c(rep(1,16), rep(2,8)), labels = c("grazed","ungrazed"))
     
## Calculate multivariate dispersions
mod <- betadisper(dis, groups)
plot(mod)


## ----adonis2-by-terms---------------------------------------------------------
data(dune, dune.env)
adonis2(dune ~ Management*A1, data = dune.env, by = "terms")


## ----adonis2-by-terms-flipped-------------------------------------------------
data(dune, dune.env)
adonis2(dune ~ A1*Management, data = dune.env, by = "terms")


## ----adonis2-by-margin--------------------------------------------------------
data(dune, dune.env)
adonis2(dune ~ Management*A1, data = dune.env, by = "margin")


## ----adonis2-margin-2---------------------------------------------------------
adonis2(dune ~ Management + A1, data = dune.env, by = "margin")


## ----permanova-idea-plot, echo = FALSE----------------------------------------
data(varespec)
     
## Bray-Curtis distances between samples
dis <- vegdist(varespec)
     
## First 16 sites grazed, remaining 8 sites ungrazed
groups <- factor(c(rep(1,16), rep(2,8)), labels = c("grazed","ungrazed"))
     
## Calculate multivariate dispersions
mod <- betadisper(dis, groups)
plot(mod)


## ----permdisp-----------------------------------------------------------------
data(varespec)
dis <- vegdist(varespec) # Bray-Curtis distances
## First 16 sites grazed, remaining 8 sites ungrazed
groups <- factor(c(rep(1,16), rep(2,8)),
                 labels = c("grazed","ungrazed"))

mod <- betadisper(dis, groups)
mod


## ----permdisp-plot, fig.height = 6, fig.width = 6-----------------------------
boxplot(mod)


## ----permdisp-anova-----------------------------------------------------------
set.seed(25)
permutest(mod)


## ----permdisp-plot-it, fig.width = 6, fig.height = 6--------------------------
plot(mod)


## ----permdisp-anova-2---------------------------------------------------------
set.seed(4)
permutest(mod, pairwise = TRUE)


## ----goodness-----------------------------------------------------------------
head(goodness(mods))


## ----inertcomp----------------------------------------------------------------
head(inertcomp(mods, proportional = TRUE))


## ----spenvcor-----------------------------------------------------------------
spenvcor(mods)


## ----intersetcor--------------------------------------------------------------
intersetcor(mods)

