#/bin/sh

case "$1" in
	testing)
		## mod server.prop
		cd ~/Bukkit_Server/
		sed -i s/25565/25566/g server.properties
		sed -i s/dd\-han\'s\ Server/dd\-han\'s\ T-Server/g server.properties
		
		## mod dynmap_configure.txt
		cd ~/Bukkit_Server/plugins/dynmap/
		sed -i s/8080/8081/g  configuration.txt
		
		## mod Towny_SQL
		cd ~/Bukkit_Server/plugins/Towny/settings/
		sed -i s/minecraft/minecraft_2/g config.yml
		;;
	orginal)
		## restore server.prop
		cd ~/Bukkit_Server/
		sed -i s/25566/25565/g server.properties
		sed -i s/dd\-han\'s\ Server/dd\-han\'s\ T-Server/g server.properties
		
		## restore dynmap_configure.txt
		cd ~/Bukkit_Server/plugins/dynmap/
		sed -i s/8081/8080/g  configuration.txt
		
		## restore Towny_SQL
		cd ~/Bukkit_Server/plugins/Towny/settings/
		sed -i s/minecraft_2/minecraft/g config.yml
		;;
	*)
		echo "Only Support two mode:  testing & orginal"
		;;
esac
