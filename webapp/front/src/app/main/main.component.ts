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

  @ViewChild('termA', { static: true }) child! : NgTerminal;
  @ViewChild('termB', { static: true }) childBis! : NgTerminal;
  retourScript = 'null';
  lesScripts =[''];
  currentScript = 'null';

  displayOption: DisplayOption = {};

  style = {
    "padding-left" : "5px",
    "background-color" : "black",
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

  selectScript(script : string){
    this.child.underlying.reset();
    this.currentScript = script;
    this.child.write('$ ' + script);
  }


  lanceScript(){
    if (this.currentScript == 'null'){
      window.alert('Veuillez sélectionner un script à lancer');
    }
    else{
      this.http.get('http://localhost:3000/api/lancescript?script=' + this.currentScript).toPromise().then(data => {
        this.retourScript = JSON.parse(JSON.stringify(data).replace(/\\n/g,"\\r\\n")).message;
        this.child.write('\r\n' + this.retourScript + '\r\n$ ');
        var icon = document.getElementById(this.currentScript);
        icon?.setAttribute("style", "color: #989034")
        this.currentScript = 'null';
      });
    }
    
  }

  scrollTop(){
    this.child.underlying.scrollToTop();
  }

  scrollBottom(){
    this.child.underlying.scrollToBottom();
  }

  scrollTopBis(){
    this.childBis.underlying.scrollToTop();
  }

  scrollBottomBis(){
    this.childBis.underlying.scrollToBottom();
  }

  editScript(){
    var terminalA = document.getElementById("terminalA");
    var termA = document.getElementById("termA");
    var terminalB = document.getElementById("terminalB");
    var termB = document.getElementById("termB");

    terminalA?.setAttribute("style", "visibility: hidden");
    termA?.setAttribute("style", "visibility: hidden");
    terminalB?.setAttribute("style", "visibility: visible");
    termB?.setAttribute("style", "visibility: visible");

    if (this.currentScript == 'null'){
      window.alert('Veuillez sélectionner un script à éditer');
    }
    else{
      this.http.get('http://localhost:3000/api/affichescript?script=' + this.currentScript).toPromise().then(data => {
        this.retourScript = JSON.parse(JSON.stringify(data).replace(/\\n/g,"\\r\\n")).message;
        this.childBis.write('\r\n' + this.retourScript);
        this.currentScript = 'null';
      });
    }
  }

  ngAfterViewInit(){
    this.child.underlying.setOption("fontSize" , "14");
    this.child.underlying.setOption('scrollback', 1000000);
    this.child.setStyle(this.style);
    this.child.write('$ ');

    this.childBis.underlying.setOption("fontSize" , "14");
    this.childBis.underlying.setOption('scrollback', 1000000);
    this.childBis.underlying.setOption('cursorStyle', 'bar');
    this.childBis.setStyle(this.style);
    

    //this.displayOption.fixedGrid = { rows: 400, cols: 100 };
    //this.child.setDisplayOption(this.displayOption);


    this.childBis.keyEventInput.subscribe(e => {
      if (e.domEvent.keyCode === 13) {
        //enter
        this.currentScript = '';
        this.childBis.write('\r\n');
      } 
      else if (!e.domEvent.altKey && !e.domEvent.ctrlKey && !e.domEvent.metaKey) {
        this.childBis.write(e.key);
        this.currentScript += e.key;
      } 
      else if (e.domEvent.keyCode === 8) {
        // backspace
        this.childBis.write('\b \b');
        console.log(this.childBis.underlying.getSelection());
      }
    });


  }

}