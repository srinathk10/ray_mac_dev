# ray_mac_dev

Apache Ray containerized developer environment for Mac


## Install Docker for Mac

Install your favourite dev tools for Mac and Docker before proceeding.


## Clone Apache Ray

Follow the instructions [here](https://docs.ray.io/en/latest/ray-contribute/development.html#id1) and clone the ray project.

```sh
srinath.krishnamachari@srinath ray_mac_dev % pwd
/Users/srinath.krishnamachari/Anyscale/ray_mac_dev

srinath.krishnamachari@srinath ray_mac_dev % git clone https://github.com/ray-project/ray.git
Cloning into 'ray'...
remote: Enumerating objects: 366231, done.
remote: Counting objects: 100% (422/422), done.
remote: Compressing objects: 100% (354/354), done.
remote: Total 366231 (delta 159), reused 225 (delta 68), pack-reused 365809 (from 1)
Receiving objects: 100% (366231/366231), 411.77 MiB | 8.03 MiB/s, done.
Resolving deltas: 100% (283276/283276), done.
Updating files: 100% (8277/8277), done.
```


## Build the Ray dev container

Build the container image running below commands.

```sh
srinath.krishnamachari@srinath ray_mac_dev % pwd
/Users/srinath.krishnamachari/Anyscale/ray_mac_dev

srinath.krishnamachari@srinath ray_mac_dev % ./devSetup.sh --build
...
```

It should create 'ray-build' container.
```sh
srinath.krishnamachari@srinath ray_mac_dev % docker images | grep ray-build
ray-build     latest    ae0f39e82e11   About a minute ago   4.82GB
srinath.krishnamachari@srinath ray_mac_dev %

```


## Run the Ray dev container

To run the dev container, run the below command.

```sh
srinath.krishnamachari@srinath ray_mac_dev % ./devSetup.sh --run
Running new Docker container mounting /home/srinath_krishnamachari/Anyscale...
7fd26b3f3569e5c8d7a3e37cb13560836fef8c2bdf28ca39220ceb03f3cf6e00
Entering the container...
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

srinath_krishnamachari@docker-desktop$

srinath.krishnamachari@srinath ray_mac_dev % docker ps
CONTAINER ID   IMAGE       COMMAND       CREATED          STATUS          PORTS     NAMES
7fd26b3f3569   ray-build   "/bin/bash"   58 seconds ago   Up 57 seconds             ray-build
srinath.krishnamachari@srinath ray_mac_dev %

```


## Enter the Ray dev container

To enter the dev container, run './devSetup.sh --run' or './devSetup.sh --exec bash'.


```sh
srinath.krishnamachari@srinath ray_mac_dev % ./devSetup.sh --run
Container 'ray-build' is already running.
Entering the container...
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

srinath_krishnamachari@docker-desktop$
```

```sh
srinath.krishnamachari@srinath ray_mac_dev % ./devSetup.sh --exec bash
Executing command inside 'ray-build' container...
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

srinath_krishnamachari@docker-desktop$
```


## Build Ray

Follow the instructions [here](https://docs.ray.io/en/latest/ray-contribute/development.html#building-ray-on-linux-macos-full) and build the project. Note that the build commands need to be run inside the container.

If your build fails with below error, limit the resources consumed by bazel and try again. Build may just run a lot slower, but should run to completion.

```sh
srinath_krishnamachari@docker-desktop$ pip install -e . --verbose
...
...
    gcc: fatal error: Killed signal terminated program cc1plus
    compilation terminated.
    [6,940 / 7,191] checking cached actions
    INFO: Elapsed time: 444.888s, Critical Path: 169.09s
    INFO: 6940 processes: 1590 internal, 5344 linux-sandbox, 6 local.
    FAILED: Build did NOT complete successfully
    Traceback (most recent call last):
      File "<string>", line 2, in <module>
      File "<pip-setuptools-caller>", line 34, in <module>
      File "/home/srinath_krishnamachari/Anyscale/ray/python/setup.py", line 775, in <module>
        setuptools.setup(
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/__init__.py", line 117, in setup
        return distutils.core.setup(**attrs)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/_distutils/core.py", line 183, in setup
        return run_commands(dist)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/_distutils/core.py", line 199, in run_commands
        dist.run_commands()
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/_distutils/dist.py", line 954, in run_commands
        self.run_command(cmd)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/dist.py", line 950, in run_command
        super().run_command(command)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/_distutils/dist.py", line 973, in run_command
        cmd_obj.run()
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/command/develop.py", line 35, in run
        self.install_for_development()
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/command/develop.py", line 112, in install_for_development
        self.run_command('build_ext')
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/_distutils/cmd.py", line 316, in run_command
        self.distribution.run_command(command)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/dist.py", line 950, in run_command
        super().run_command(command)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/setuptools/_distutils/dist.py", line 973, in run_command
        cmd_obj.run()
      File "/home/srinath_krishnamachari/Anyscale/ray/python/setup.py", line 763, in run
        return pip_run(self)
      File "/home/srinath_krishnamachari/Anyscale/ray/python/setup.py", line 665, in pip_run
        build(True, BUILD_JAVA, True)
      File "/home/srinath_krishnamachari/Anyscale/ray/python/setup.py", line 608, in build
        return bazel_invoke(
      File "/home/srinath_krishnamachari/Anyscale/ray/python/setup.py", line 388, in bazel_invoke
        result = invoker([cmd] + cmdline, *args, **kwargs)
      File "/home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/subprocess.py", line 373, in check_call
        raise CalledProcessError(retcode, cmd)
    subprocess.CalledProcessError: Command '['bazel', 'build', '--verbose_failures', '--', '//:ray_pkg', '//cpp:ray_cpp_pkg']' returned non-zero exit status 1.
    error: subprocess-exited-with-error
```

Here is the command to limit bazel resources during build.

```sh
srinath_krishnamachari@docker-desktop$ bazel build --local_ram_resources=2048 --jobs=2 --verbose_failures -- //:ray_pkg //cpp:ray_cpp_pkg
...
INFO: Elapsed time: 1125.017s, Critical Path: 44.05s
INFO: 262 processes: 2 internal, 255 linux-sandbox, 5 local.
INFO: Build completed successfully, 262 total actions

srinath_krishnamachari@docker-desktop$ pip install -e . --verbose
Using pip 24.2 from /home/srinath_krishnamachari/.conda/envs/myenv/lib/python3.9/site-packages/pip (python 3.9)
Obtaining file:///home/srinath_krishnamachari/Anyscale/ray/python
...
    Installed /home/srinath_krishnamachari/Anyscale/ray/python
Successfully installed ray

```


## Updating Conda Packages

Update packages in `env/environment.yml` file and run below command to pull in the new packages in your env.

```sh
conda env update --file env/environment.yml
```
