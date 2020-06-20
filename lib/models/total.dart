

import 'dart:convert';

Global globalFromJson(String str) => Global.fromJson(json.decode(str));

String globalToJson(Global data) => json.encode(data.toJson());

class Global {
    Global({
        this.totalConfirmed,
        this.totalDeaths,
        this.totalRecovered,
    });

    int totalConfirmed;
    int totalDeaths;
    int totalRecovered;

    factory Global.fromJson(Map<String, dynamic> json) => Global(
        totalConfirmed: json["TotalConfirmed"],
        totalDeaths: json["TotalDeaths"],
        totalRecovered: json["TotalRecovered"],
    );

    Map<String, dynamic> toJson() => {
        "TotalConfirmed": totalConfirmed,
        "TotalDeaths": totalDeaths,
        "TotalRecovered": totalRecovered,
    };
}
