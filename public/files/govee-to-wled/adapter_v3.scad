// Govee H70A3 adapter - v3: TE Superseal 1.0 socket terminal 3-1447221-4
// UNPOWERED fit prototype. Terminal dimensions taken from TE STEP model C-3-1447221-4 rev C.
// part = "body" | "collar" | "backshell" | "comb_top" | "comb_bot" | "assembly"
part="body";
$fn=96;

// ---- strip-side interface, confirmed by v1/v2 fit ----
nose_w=9.91; nose_h=8.99; nose_clear=0.20;
key_w=1.4; key_d=0.9;
thread_minor=12.95; pitch=1.4;
pin_x=2.95; row_top=1.6; row_bot=-1.3;   // pin layout, confirmed by v1
nose_len=6.5; oring_h=0.9;               // O-ring land for 9.5 x 1.0 ring
shoulder_d=12.3;

// ---- TE 3-1447221-4 (from STEP) ----
t_barrel_d=1.94;   // barrel OD
t_barrel_l=8.41;   // front face to start of first collar
t_bead_d=2.4;      // both collars
t_neck_d=1.25;     // neck between collars
t_neck_start=9.925;// from front face
t_neck_end=11.525;

// ---- v3 design values ----
lip=0.6; pin_entry=1.5;
bore=2.25;                 // barrel bore (prints smaller)
cbore=2.7;                 // first-collar pocket
stem_d=10.6;               // larger than v2 so the collar pockets keep a wall
shoulder_h=0.8; cone_h=0.85;
body_h=lip+t_neck_start-0.025;          // rear face lands at the neck start = 10.5
stem_len=body_h-nose_len-shoulder_h-cone_h;
cbore_h=body_h-lip-t_barrel_l;          // 1.49: first collar seats on this step
comb_t=1.4; slot_w=1.5;
fil_pin=1.9; pin_y=-4.35; pin_z=1.0;
flat_y=stem_d/2-0.5;

function fract(x)=x-floor(x);
function groove(t)=let(q=abs(fract(t)-0.5)) q<=1/16?1:q>=3/8?0:(3/8-q)/(5/16);
module thread_void(p,d,h){
 n=96; nz=ceil((h+2)*24/p); z0=-1; dz=(h+2)/nz;
 pts=[for(j=[0:nz]) for(i=[0:n-1]) let(z=z0+j*dz,a=360*i/n,
 r=d/2+5*sqrt(3)/16*p*groove(z/p-i/n)) [r*cos(a),r*sin(a),z]];
 sides=[for(j=[0:nz-1]) for(i=[0:n-1]) for(t=[0:1]) let(k=j*n+i,l=j*n+(i+1)%n) t==0?[k,l+n,l]:[k,k+n,l+n]];
 polyhedron(points=pts,faces=concat(sides,[[for(i=[0:n-1])i]],[[for(i=[n-1:-1:0])nz*n+i]]),convexity=12);
}
module round_nose(){ circle(r=(nose_w-nose_clear)/2); }
module outline(){
 r=(nose_w-nose_clear)/2; flat=nose_h-nose_clear-r;
 difference(){
  intersection(){ circle(r=r); translate([-10,-flat]) square([20,20]); }
  translate([-key_w/2,r-key_d]) square([key_w,3]);
 }
}
module top_pos(){ for(x=[-pin_x/2,pin_x/2]) translate([x,row_top]) children(); }
module bot_pos(){ for(x=[-pin_x,0,pin_x]) translate([x,row_bot]) children(); }
module all_pos(){ top_pos() children(); bot_pos() children(); }

module body(){
 zc=stem_len; zs=zc+cone_h; zn=zs+shoulder_h; zk=zn+oring_h; ztip=body_h;
 difference(){
  union(){
   cylinder(h=stem_len,d=stem_d);
   translate([0,0,zc]) cylinder(h=cone_h,d1=stem_d,d2=shoulder_d);
   translate([0,0,zs]) cylinder(h=shoulder_h,d=shoulder_d);
   translate([0,0,zn]) linear_extrude(oring_h) round_nose();
   translate([0,0,zk]) linear_extrude(ztip-zk-.5) outline();
   translate([0,0,ztip-.5]) linear_extrude(.5,scale=.94) outline();
  }
  all_pos(){
   translate([0,0,-1]) cylinder(h=cbore_h+1,d=cbore,$fn=40);            // collar pocket
   translate([0,0,cbore_h-.01]) cylinder(h=.25,d1=cbore,d2=bore,$fn=40); // seat chamfer
   translate([0,0,0]) cylinder(h=ztip-lip,d=bore,$fn=40);                // barrel bore
   translate([0,0,ztip-lip-.01]) cylinder(h=lip+.02,d=pin_entry,$fn=32); // pin entry
   translate([0,0,ztip-.3]) cylinder(h=.31,d1=pin_entry,d2=pin_entry+.6,$fn=32);
  }
  translate([-6,flat_y,-1]) cube([12,2,stem_len+1]);                     // key-side flat
  translate([-10,pin_y,pin_z]) rotate([0,90,0]) cylinder(h=20,d=fil_pin,$fn=32);
 }
}
module comb_blank(){ intersection(){ circle(d=stem_d); translate([-10,-10]) square([20,10+flat_y]); } }
module slot(y0,yc){ hull(){ translate([0,y0]) circle(d=slot_w,$fn=32); translate([0,yc]) circle(d=slot_w,$fn=32); } }
module comb_top(){
 linear_extrude(comb_t) difference(){
  intersection(){ comb_blank(); translate([-10,0.2]) square([20,20]); }
  for(x=[-pin_x/2,pin_x/2]) translate([x,0]) slot(-1,row_top);
 }
}
module comb_bot(){
 linear_extrude(comb_t) difference(){
  intersection(){ comb_blank(); translate([-10,-20]) square([20,20.1]); }
  for(x=[-pin_x,0,pin_x]) translate([x,0]) slot(1,row_bot);
 }
}
module backshell(){
 tube=13; skirt=comb_t+stem_len-.2; od=13.3; zs=tube;
 difference(){
  union(){
   cylinder(h=tube+skirt,d=od);
   for(z=[2,5]) translate([0,0,z]) cylinder(h=1,d=od+1);
  }
  translate([0,0,-.01]) cylinder(h=tube+.02,d=9.6);                     // clears rear collars + crimps
  translate([0,0,zs]) linear_extrude(skirt+1) intersection(){ circle(d=stem_d+.3); translate([-10,-10]) square([20,10+flat_y+.15]); }
  translate([-10,pin_y,zs+comb_t+pin_z]) rotate([0,90,0]) cylinder(h=20,d=fil_pin,$fn=32);
 }
}
module collar(){
 th=6.5; h=cone_h+th;
 difference(){
  cylinder(h=h,r=9,$fn=12);
  translate([0,0,-.01]) cylinder(h=cone_h+.02,d1=stem_d+.5,d2=shoulder_d+.5);
  translate([0,0,cone_h+1]) thread_void(pitch,thread_minor,th);
  translate([0,0,h-.65]) cylinder(h=.67,d1=thread_minor,d2=thread_minor+1.25);
 }
}
// crude terminal for the assembly check only
module terminal(){
 color("silver"){ cylinder(h=t_barrel_l,d=t_barrel_d,$fn=24);
  translate([0,0,-(t_neck_start-t_barrel_l)]) cylinder(h=t_neck_start-t_barrel_l,d=t_bead_d,$fn=24);
  translate([0,0,-(t_neck_end-t_barrel_l)]) cylinder(h=t_neck_end-t_neck_start,d=t_neck_d,$fn=24);
  translate([0,0,-(12.83-t_barrel_l)]) cylinder(h=12.83-t_neck_end,d=t_bead_d,$fn=24);
  translate([0,0,-(23.1-t_barrel_l)]) cylinder(h=23.1-12.83,d=1.8,$fn=24); }
}
module assembly(){
 difference(){
  union(){
   body();
   translate([0,0,-comb_t-.05]) { color("orange") comb_top(); color("gold") comb_bot(); }
   color("gray",.6) translate([0,0,stem_len]) collar();
   color("teal",.6) translate([0,0,-13-comb_t-.05]) backshell();
   all_pos() translate([0,0,body_h-lip-t_barrel_l]) terminal();
  }
  translate([0,-20,-30]) cube([20,40,60]);   // section cut
 }
}

// ---- tapered backshell for a jacketed cable + 1/2" 3:1 adhesive heat shrink ----
cable_d=6.5;          // ENERJOUR UL2464 20AWG 5C jacket, 6.5 +/-0.25 (22AWG version is 5.6)
cable_hole=7.2;
tail_od=10.0; tail_len=10; cone_len=8; cav_len=13; cav_d=9.6;
module backshell_taper(){
 skirt=comb_t+stem_len-.2; od=13.3;
 z1=tail_len; z2=z1+cone_len; z3=z2+cav_len; zt=z3+skirt;
 difference(){
  union(){
   cylinder(h=tail_len,d=tail_od);
   for(z=[2,5,8]) translate([0,0,z]) cylinder(h=.8,d1=tail_od,d2=tail_od+1.1);   // barbs, grip the heat shrink
   translate([0,0,z1]) cylinder(h=cone_len,d1=tail_od,d2=od);
   translate([0,0,z2]) cylinder(h=zt-z2,d=od);
  }
  translate([0,0,-.01]) cylinder(h=z1+.02,d=cable_hole);
  translate([0,0,z1]) cylinder(h=cone_len+.01,d1=cable_hole,d2=cav_d);        // wire fan-out / sealant cup
  translate([0,0,z2]) cylinder(h=cav_len+.01,d=cav_d);
  translate([0,0,z3]) linear_extrude(skirt+1) intersection(){ circle(d=stem_d+.3); translate([-10,-10]) square([20,10+flat_y+.15]); }
  translate([-10,pin_y,z3+comb_t+pin_z]) rotate([0,90,0]) cylinder(h=20,d=fil_pin,$fn=32);
 }
}
if(part=="backshell_taper") backshell_taper(); else if(part=="body") body(); else if(part=="collar") collar(); else if(part=="backshell") backshell();
else if(part=="comb_top") comb_top(); else if(part=="comb_bot") comb_bot(); else assembly();
