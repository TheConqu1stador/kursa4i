   M S B A M L   `   `   `  ����D  @DB_Client, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null%clr-namespace:DB_Client	DB_Client  5   	       DB_Client.Runner   5   	   R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   %cclr-namespace:DB_Client     5   	     � WindowStartupLocation$  Manual=�5   	    � Title$ Runner��5	   	   $	��450��6   $	��370��6%    � 	Resources 5
         DB_Client.RoutineViewModel   RKey  Routines �� Source �� Source �� Path"  DB_Client.ParameterViewModel  PKey  
Parameters��%�   &	        &	      7   &	 P     &	 c     7    5   
   6   �� 5   
    5   	   �� 8   $ Routines�5   	     5   
   6   �� 5   
    5   	   �� 8   $ 
Parameters�5   	   5      .��5      � -   5        $��
RunnerGrid��5      .+�5   
   �� -   5        $��comboBox��5      $
��Left=�6#   $��	10,10,0,0q�6>   $	��Top=�6Q   $	��259��6i   $��25��5   �    � DataContext 6   �� # [  ��6J   �� $ Routines� �� SelectedItem 6p   �� $ Routine���5      �� 5      .R�5      ��  �� Orientation$ 
Horizontal=�6!   .+�5      �� ��6$   �� *Type+	 �� StringFormat$	 -{0}- ���� 5      ��6$   �� *Name+5      5      5       �� 5!   
   -   5        $��ArgsItemControl��5!      $��
10,49,10,0q�6�    6.   �� # [ ��6c   �� $ 
Parameters���5"      �� 5#      .R�5$      �� 
�������$��1,1,1,1q�60   ._�5%      � $��0,0,0,10q�6   
 � ColumnDefinitions
 5&      �� 5'   "   $	��160 �63   �� 5(   "   $��70 �63   �� 5)   "   $	��120 �63   .+�5+      �� $��0��6>   ��6(   �� *Type+6>   �� 5,      $��1��6>   ��6(   �� *Name+6>   �� 5-       ��Name$ textBox��6<   $��2��6M   ��6&   �� *Text+6M   5.      5/      50      52      �� 53   
   -   5        $��ExecuteButton��53      $��Execute��6&   $
��Left=�68   $��
283,10,0,0q�6S   $	��Top=�6g   $��70��6   $��25��6�   6�   54      55      