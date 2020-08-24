# docker
Self-Contained Docker C# Blazor Web API host

There are currently four (5) repositories. This is the repository that is an ASP.NET server and contains the entire codebase as a submodule.

```
git clone --recursive git@github.com:The-Revolution-Network/docker.git TheRevolutionNetwork.docker
cd TheRevolutionNetwork.docker
make build
make launch
see-also make stop, make rm-latest, make help
```

generally the submodules are equivalent with the master branch of each repo, you usually can git checkout master in each submodule and have no changes.

TODO: release internal docker makefile include
