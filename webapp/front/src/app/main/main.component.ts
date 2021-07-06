import { Component, AfterViewInit, ViewChild } from '@angular/core';
import { NgTerminal, NgTerminalComponent } from 'ng-terminal';
import {HttpClient} from '@angular/common/http';
import { DisplayOption } from 'ng-terminal';
import { Terminal } from 'xterm';


@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements AfterViewInit{

  @ViewChild('term', { static: true }) child! : NgTerminal;
  retourScript = 'null';
  lesScripts =[''];
  currentScript = 'null';

  displayOption: DisplayOption = {};

  style = {
    "padding-left" : "5px",
    "background-color" : "black"
  }

  constructor(private http : HttpClient){
    this.http.get('http://localhost:3000/api/ls').toPromise().then(data => {
      var ls = JSON.stringify(data);
      var myObj = JSON.parse(ls);
      ls = myObj['message'];
      this.lesScripts = ls.split('\n');
      this.lesScripts.length --;
    });
  }

  lanceScript(){
    if (this.currentScript == 'null'){
      window.alert('Veuillez sélectionner un script à lancer');
    }
    else{
      this.http.get('http://localhost:3000/api/lancescript?script=' + this.currentScript).toPromise().then(data => {
        this.retourScript = JSON.parse(JSON.stringify(data).replace(/\\n/g,"\\r\\n")).message;
        this.child.write('\r\n' + this.retourScript + '\r\n');
        var icon = document.getElementById(this.currentScript);
        icon?.setAttribute("style", "color: #989034")
        this.currentScript = 'null';
      });
    }
    
  }

  selectScript(script : string){
    this.child.underlying.reset();
    this.currentScript = script;
    this.child.write('\r\n$ ' + script);
  }

  scrollTop(){
    this.child.underlying.scrollToTop();
  }

  scrollBottom(){
    this.child.underlying.scrollToBottom();
  }

  editScript(){
    if (this.currentScript == 'null'){
      window.alert('Veuillez sélectionner un script à éditer');
    }
    else{
      this.http.get('http://localhost:3000/api/affichescript?script=' + this.currentScript).toPromise().then(data => {
        this.retourScript = JSON.parse(JSON.stringify(data).replace(/\\n/g,"\\r\\n")).message;
        this.child.write('\r\n' + this.retourScript);
        this.currentScript = 'null';
      });
    }
  }

  ngAfterViewInit(){
    this.child.underlying.setOption("fontSize" , "14");
    this.child.underlying.setOption('scrollback', 10000000);
    this.child.setStyle(this.style);

    //this.displayOption.fixedGrid = { rows: 400, cols: 100 };
    //this.child.setDisplayOption(this.displayOption);
  }

}
