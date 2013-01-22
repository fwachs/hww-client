class Mission {
    var id;
    var name;
    var type;
    var ssp;
    var gameBucks;
    var diamonds;
    var tasks;
    var image;

    public function Mission (id, name, type, ssp, gameBucks, diamonds, image) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.ssp = ssp;
        this.gameBucks = gameBucks;
        this.diamonds = diamonds;
        this.image = image;
        this.tasks = new Array();
    }

    public function addTask(task) {
        this.tasks.append(task);
    }

    public function getCurrency() {
        if (diamonds == null || diamonds == 0) {
            return "gameBucks";
        }
        return "diamonds"; 
    }

    public function getReward() {
        var currency = this.getCurrency();
        if (currency == "diamonds") {
            return this.diamonds;
        }
        return this.gameBucks;
    }
}

class MissionTask {

    var itemId;
    var amount;
    var name;

    public function MissionTask (itemId, name, amount) {
        this.itemId = itemId;
        this.amount = amount;
        this.name = name;
    }
}

class RemodelMissionTask {

    var level;
    var name;

    public function RemodelMissionTask (name, level) {
        this.name = name;
        this.level = level;
    }
}
