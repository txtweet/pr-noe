import { Component, AfterViewInit, ViewChild } from '@angular/core';
import { NgTerminal } from 'ng-terminal';
import {HttpClient} from '@angular/common/http';
import {Router} from '@angular/router';


@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent  {

  @ViewChild('term', { static: true }) child! : NgTerminal;
  retourScript = 'null';
  lesScripts =[''];
  currentScript = 'null';

  constructor(private http : HttpClient, private router : Router){
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
        this.retourScript = JSON.stringify(data);
        var myObj = JSON.parse(this.retourScript);
        this.retourScript = myObj['message'];
        this.child.write('\r\n' + this.retourScript + '\r\n');
        var icon = document.getElementById(this.currentScript);
        icon?.setAttribute("style", "color: #3E6C2A")
        this.currentScript = 'null';
      });
    }
    
  }


  selectScript(script : string){
    this.currentScript = script;
    var extension = script.split('.')[1];
    if (extension == 'coffee'){
      this.child.write('\r\n$ coffee ./' + script);
    }
    else{
      this.child.write('\r\n$ ./' + script);
    }
  }


  clear(){
    this.child.underlying.reset();
    window.scroll(0,0);
  }

}
