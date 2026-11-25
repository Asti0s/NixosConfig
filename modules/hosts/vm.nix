{den, ...}: {
  den = {
    hosts.x86_64-linux.vm = {
      users.asti0s = {};
    };

    aspects.vm = {
      includes = [den.batteries.user-aspects];
    };
  };
}
