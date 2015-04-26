_Names on Nodes_ provides an automated bridge between biology and biological nomenclature. Phylogenetic definitions are stored as [MathML](http://www.w3.org/Math/), to be applied to phylogenetic hypotheses. Rank-based definitions may also be applied, using distance metrics. The principles of this application were laid out by [Keesey (2007)](http://dx.doi.org/doi:10.1111/j.1463-6409.2007.00302.x).

The user interface of _Names on Nodes_ is built in Flash Builder, using Adobe's Flex framework, Flare visualization tools, and Keesey's [Three-Pound Monkey Brain ActionScript](http://code.google.com/p/a3lbmonkeybrain-as3/) library. The server component is built with Java for a JBoss server, using BlazeDS and Hibernate. The database is PostgreSQL.

This project is divided into three subprojects:

  * `namesonnodes-html`: the static website accompanying the application, including index page and namespace definitions
  * `namesonnodes-lib`: the ActionScript libraries used by the application; these could potentially be reused for other applications
  * `namesonnodes-app`: the rich Internet application itself, including the server component, UI components, and connectivity logic

The current status of this project is **prealpha**. It not complete, and will not compile to a useable web application right now, but much of the underlying code and test cases are ready.