class Mission {
    var id;
    var name;
    var type;
    var ssp;
    var gameBucks;
    var diamonds;
    var tasks;

    public function Mission (id, name, type, ssp, gameBucks, diamonds) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.ssp = ssp;
        this.gameBucks = gameBucks;
        this.diamonds = diamonds;
        this.tasks = new Array();
    }

    public function addTask(task) {
        this.tasks.append(task);
    }

    public function getCurrency() {
        if (diamonds == null || diamonds == null) {
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

    public function MissionTask (itemId, amount) {
        this.itemId = itemId;
        this.amount = amount;
    }
}

class RemodelMissionTask {

    var level;

    public function RemodelMissionTask (level) {
        this.level = level;
    }
}
