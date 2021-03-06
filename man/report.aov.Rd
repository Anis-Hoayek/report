% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report.aov.R
\name{report.aov}
\alias{report.aov}
\title{ANOVAs Report}
\usage{
\method{report}{aov}(
  model,
  interpretation = "field2013",
  omega_squared = "partial",
  eta_squared = NULL,
  epsilon_squared = NULL,
  ...
)
}
\arguments{
\item{model}{Object of class \code{aov}, \code{anova} or \code{aovlist}.}

\item{interpretation}{Effect size interpretation set of rules (see \link[effectsize]{interpret_omega_squared}).}

\item{omega_squared}{Compute omega squared as index of effect size. Can be \code{"partial"} (adjusted for effect size) or \code{"raw"}.}

\item{eta_squared}{Compute eta squared as index of effect size. Can be \code{"partial"} (adjusted for effect size) or \code{"raw"}.}

\item{epsilon_squared}{Compute epsilon squared as index of effect size.}

\item{...}{Arguments passed to or from other methods.}
}
\description{
Create a report of an ANOVA.
}
\examples{
data <- iris
data$Cat1 <- rep(c("A", "B"), length.out = nrow(data))
model <- aov(Sepal.Length ~ Species * Cat1, data = data)
r <- report(model)
r
table_short(r)
}
\seealso{
report
}
