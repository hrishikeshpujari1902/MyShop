#include <iostream>
#include<bits/stdc++.h>
using namespace std;
class tbtnode
{
    char data[20];
    bool rbit;
    bool lbit;
    tbtnode *rightc;
    tbtnode *leftc;
    friend class tbt;
    public:
      tbtnode();
};
tbtnode::tbtnode()
{   
    
    rightc=leftc=NULL;
    lbit=1;
    rbit=1;
}
class tbt
{
   tbtnode *head;
   public:
   void create();
   void preorder();
   void inorder();
   tbtnode* insuccr(tbtnode *temp);
   tbt();
};
tbt::tbt()
{
   head=new tbtnode(); 
   head->rbit=0;
   head->leftc=head->rightc=head;
}
void tbt::create()
{
    char ch2;
    tbtnode *root=new tbtnode;
    cout<<"Enter Root data:";
    cin>>root->data;
    head->lbit=0;
    root->leftc=root->rightc=head;
    head->leftc=root;
    do{
        int flag=0;
        tbtnode* temp=root;
        tbtnode *curr=new tbtnode;
        cout<<"Enter data:";
        cin>>curr->data;
    
        while(flag==0){   
            char ch1;
            cout<<"Do you want to add data to left or right of"<<temp->data<<"?(l/r):";
            cin>>ch1;
            if(ch1=='l'){
                if(temp->lbit==1){
                    curr->rightc=temp;
                    curr->leftc=temp->leftc;
                    temp->leftc=curr;
                    temp->lbit=0;
                    flag=1;
                }
                else{
                    temp=temp->leftc;
                }
            }
            if(ch1=='r'){
                if(temp->rbit==1){
                    curr->leftc=temp;
                    curr->rightc=temp->rightc;
                    temp->rightc=curr;
                    temp->rbit=0;
                    flag=1;
                }
                else{
                  temp=temp->rightc;
                }
            }
        }
        cout<<"Do you want to continue?(y/n):";
        cin>>ch2;
        }while(ch2=='y'||ch2=='Y');
    }
void tbt::inorder()
{
    tbtnode* temp=head;
    while(1)
    {
        temp=insuccr(temp);
        if(temp==head) 
           break;
        cout<<temp->data<<" ";
    }
}
tbtnode* tbt:: insuccr(tbtnode* head)
{   
    tbtnode *x,*temp;
    x=head->rightc;
    if(head->rbit==0)
    {
        while(x->lbit==0)
        x=x->leftc;
    }
    return x;
}
void tbt::preorder()
{   
    tbtnode* temp;
    temp=head->leftc;
    while(temp!=head)
    {
        cout<<temp->data<<" ";
        while(temp->lbit!=1)
        {
            temp=temp->leftc;
            cout<<temp->data<<" ";
        }
        while(temp->rbit==1)  
            temp=temp->rightc;
        temp=temp->rightc;
        
    }
}

int main()
{  
    tbt t;
    int i;
    do
    {
        cout<<"\n*****MENU*****\n";
        cout<<"1.CREATE TBT\n2.Inorder SUccessor\n3.Preorder SUccessor\n4.Exit\n->";
        cin>>i;
        switch(i)
        {
            case 1:
              t.create();
              break;
            case 2:
              t.inorder();
              break;
            case 3:
               t.preorder();
               break;
        default:
               cout<<"Invalid choice!";
               break;
              
        }
    }while(i!=4)
    return 0;
}
