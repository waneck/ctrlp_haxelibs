import sys.FileSystem;
using StringTools;

class Main
{
	public static function main()
	{
		// get hxml path
		var path = Sys.args()[0];
		var libs = new Map();
		function addHxml(path:String)
		{
			if (path != null && FileSystem.exists(path))
			{
				var cur = Sys.getCwd();
				for (line in sys.io.File.getContent(path).split('\n'))
				{
					var idx = line.indexOf(' ');
					if (idx < 0) idx = line.length;
					var cmd = line.substr(0,idx),
							arg = line.substr(idx);
					switch(cmd.trim())
					{
						case '-lib':
							libs[arg.trim()] = true;
						case '--cwd':
							Sys.setCwd(arg);
						case cmd if (cmd.charCodeAt(0) != '-'.code):
							// it might be another hxml file
							addHxml(cmd);
					}
				}
				Sys.setCwd(cur);
			}
		}
		addHxml(path);

		// get all lib paths
		var found = 0;
		for (lib in libs.keys())
		{
			var path = getLibPath(lib);
			if (path == null)
				continue;
			found++;
			Sys.println(path);
			// Sys.println('$lib,$path');
		}
#if debug
		if (found == 0)
		{
			Sys.println('No records found');
			Sys.println('For hxml $path and libs $libs');
		}
#end
	}

	private static function getLibPath(lib:String)
	{
		var cmd = new sys.io.Process('haxelib',['path',lib]);
		var ret = cmd.stdout.readAll().toString().split('\n');
		if (cmd.exitCode() == 0)
			for (path in ret)
				if (FileSystem.exists(path))
					return path;
		return null;
	}
}
