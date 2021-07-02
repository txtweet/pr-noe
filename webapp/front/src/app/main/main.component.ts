import { Component, AfterViewInit, ViewChild } from '@angular/core';
import { NgTerminal } from 'ng-terminal';
import {HttpClient} from '@angular/common/http';
import {Router} from '@angular/router';


@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements AfterViewInit {

  @ViewChild('term', { static: true }) child! : NgTerminal;
  retourScript = 'null';
  lesScripts =[''];

  constructor(private http : HttpClient, private router : Router){
    this.http.get('http://localhost:3000/api/ls').toPromise().then(data => {
      var ls = JSON.stringify(data);
      var myObj = JSON.parse(ls);
      ls = myObj['message'];
      this.lesScripts = ls.split('\n');
      this.lesScripts.length --;
    });
  }

  getCmd(){
    this.http.get('http://localhost:3000/api/default').toPromise().then(data => {
      this.retourScript = JSON.stringify(data);
      var myObj = JSON.parse(this.retourScript);
      this.retourScript = myObj['message'];
      this.child.write('\r\n>> ');
      this.child.write(this.retourScript);
    });
  }

  /*
  nextRoute(){
    if (this.lance == false) {
      window.alert("Veuillez lancer le script avant de passer à la prochaine étape");
    }
    else{
      if (this.router.url === '/firstscript'){
        this.router.navigate(['/secondscript']);
      }
      else if (this.router.url === '/secondscript'){
        this.router.navigate(['/fini']);
      }
    }
  }
  */


  ngAfterViewInit(){
    this.child.write('$ ');
  }

}
