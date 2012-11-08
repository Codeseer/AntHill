exports.index = function(req, res){
  projects = new Array();
  projects.push({name:'Project 1', })
  res.render('project/index', { title: 'AntHill' });
};