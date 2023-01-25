
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Doctoer_Medicine_Order.aspx.cs" Inherits="Design_Store_Doctoer_Medicine_Order" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
  
    <style type="text/css">
        .auto-style1 {
            width: 458px;
        }

        .auto-style2 {
            width: 15%;
        }
    </style>
    
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
 
      <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
       <script type="text/javascript">

           var onparmacyItem = function () {
               debugger;
               var pharmacyItem = $('#pharmacyItem');
               var grid = pharmacyItem.combogrid('grid');
               var selectedItems = grid.datagrid('getSelected');
               calculateQuantity();
               if (selectedItems != null)
                   if (selectedItems.ItemID.split('#')[9] == 'LSHHI5') {
                       $('.indentMedicalRequiredField').addClass('requiredField');
                       $('#txtRequestedQty').prop('disabled', true);
                   }
                   else {
                       $('.indentMedicalRequiredField').addClass('requiredField');
                       $('#txtRequestedQty').prop('disabled', false);
                   }
               else {
                   $('.indentMedicalRequiredField').addClass('requiredField');
                   $('#txtRequestedQty').prop('disabled', false);
               }


           }



           var calculateQuantity = function () {

               if ($("#pharmacyItem").combogrid('getValue') === null || $("#pharmacyItem").combogrid('getValue') === undefined) {
                   return false;
               }

               var quantity=0;
               var SubcategoryId = $("#pharmacyItem").combogrid('getValue').split('#')[1];
               if (SubcategoryId == "" || SubcategoryId == undefined || SubcategoryId == null) {
                   modelAlert("Select Item First.");
                   return false;
               }

               if (SubcategoryId == "114" || SubcategoryId == "115" || SubcategoryId == "116" || SubcategoryId == "120" || SubcategoryId == "121" || SubcategoryId == "122") {

                   quantity = precise_round(1, 2);

               } else {
                   // var dose = Number($('#txtDose').val());
                   var times = Number($('#ddlInterval').val().split('#')[1]);
                   var duratation = Number($('#ddlDuration').val());

                   quantity = precise_round((times * duratation), 2);
               }
               




               $('#txtRequestedQty').val(quantity);
           }

       </script>

     <form id="form1" runat="server">
    
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Medicine Order</b>
                <br />
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" style="display:none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display:none"   runat="server" clientidmode="Static"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnIPD_CaseTypeID"    runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnRoomID"   runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnCanIndentMedicalItems"   runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnCanIndentMedicalConsumables"   runat="server" clientidmode="Static" style="display:none"></span>
            </div>
             
            <div class="POuter_Box_Inventory">
                
                <div class="Purchaseheader" style="text-align: left;">
                Medicine Order
                </div>
                <div id="divMdOrder">
                    
                    <div class="row">
                        <div class="col-md-4">
                            Department : 
                        </div>
                           <div class="col-md-10" style="margin-left:-42px">
                                  <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static" Width="225px"></asp:DropDownList>
                        
                         </div>

                        <div class="col-md-3">
                           Sub Group :&nbsp; 
                        </div>
                        <div class="col-md-5">
                           <select id="ddlSubCategory" style="width:225px"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                             Medicine Name : 
                        </div>
                           <div class="col-md-9" style="margin-left:-42px">
 <input id="pharmacyItem"  tabindex="1" class="easyui-combogrid" style="width: 250px;" data-options="
			panelWidth: 600,
			idField: 'ItemID',
			textField: 'ItemName',
            mode:'remote',                                       
			url: 'Doctoer_Medicine_Order.aspx?cmd=item',
            loadMsg: 'Serching... ',
			method: 'get',
            pagination:true,
            rownumbers:true,
            fit:true,
            border:false,   
            cache:false,  
            nowrap:true,                                                   
            emptyrecords: 'No records to display.',
            mode:'remote',
            onHidePanel:onparmacyItem ,
            onBeforeLoad: function (param) {
                   var Type = 0;
                   var PanelID= $('#spnPanelID').text();
                   var DeptLegerNo=$('#ddlDepartment').val();
                   var SubcategoryID = $('#ddlSubCategory').val();
                   var canIndentMedicalItems=$('#spnCanIndentMedicalItems').text();
                   var canIndentMedicalConsumables=$('#spnCanIndentMedicalConsumables').text();
                   param.canIndentMedicalItems=canIndentMedicalItems;
                   param.canIndentMedicalConsumables=canIndentMedicalConsumables;
                   param.Type= Type;
                   param.PanelID = PanelID;
                   param.DeptLegerNo = DeptLegerNo;
                   param.SubcategoryID = SubcategoryID;},
			columns: [[
				{field:'ItemName',title:'ItemName',width:200,align:'left'},
                {field:'AvlQty',title:'Avl. Qty.',width:70,align:'center'}
			]],
			fitColumns: true
		">

                         </div>
 </div>
                    <div class="row">
                        <div class="col-md-3">
                            Dose / Unit : 
                        </div>
                        <div class="col-md-2">
                             <input type="text" id="txtDose" style="width:80px" tabindex="6"  class="requiredField ItDoseTextinputNum indentMedicalRequiredField" allowCharsCode="45,47"   onlynumber="10" decimalplace="4" max-value="99009999" class="requiredField"  />  
                                       
                        </div>
                        <div class="col-md-2">
                             <select id="txtUnit" class="requiredField indentMedicalRequiredField"></select>
                                
                        </div>
                        

<div class="col-md-2">
                        Interval: 
                    </div>

                      <div class="col-md-3">
                           <select id="ddlInterval" onchange="ddlintervalchange();" style="width:80px" tabindex="4" class="requiredField indentMedicalRequiredField" ></select> 
                        <span style="color: red; font-size: 10px;display:none">*</span>
                                                
                    </div>
                        <div class="col-md-2">
                          <label for="chkIsNow">Now</label>   <input type="checkbox" id="chkIsNow" onclick="GetNow()"/>
                        </div>


                         <div class="col-md-2">
                        Duration : 
                    </div>

                      <div class="col-md-2">
                           <select id="ddlDuration" onchange="calculateQuantity();" style="width:80px" tabindex="4" class="requiredField indentMedicalRequiredField" ></select> 
                                                     <span style="color: red; font-size: 10px;display:none">*</span>
                                                
                    </div>
                        <div class="col-md-2">
                          Route : 
                        </div>
                        <div class="col-md-2" style="margin-left: -24px">
                              <select id="ddlRoute" style="width:80px"  tabindex="5" class="requiredField indentMedicalRequiredField"></select>
                        </div>
                        <div class="col-md-1">
                            Qty.:
                        </div>
                        <div class="col-md-1">
                               <input  type="text" id="txtRequestedQty" style="width:50px"  class="requiredField"  tabindex="9"  onlynumber="7" decimalplace="2" max-value="9999"  /> 
                                  
                        </div>
                    </div>
                    <div class="row">
                   

                        <div class="col-md-3">
                            Start Date :&nbsp
                        </div>

                        <div class="col-md-4">
                              <asp:TextBox ID="txtSelectDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSelectDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            Times :
                        </div>

                        <div class="col-md-10" >
                              <div class="row" id="divBindTimesLabel">
                                   
                              </div>
                              
                        </div>
                        <div class="col-md-2 hidefirstDose">
                             1<sup>st</sup>Dose :
                        </div>
                        <div class="col-md-3 hidefirstDose"  >
                             <input type="text" id="txtfirstDose" class="ItDoseTextinputText txtTime required" readonly="readonly" disabled="disabled" />
                          
                        </div>

                    </div>
             
                   <div class="row">
                       <div class="col-md-3">
                           Remarks :&nbsp;
                       </div>
                       <div class="col-md-5">
                             <input type="text" id="txtRemarks" class="ItDoseTextinputText"   tabindex="7"   />
                       </div>
                       <div class="col-md-3">
                           Doctor :&nbsp;
                       </div>
                       <div class="col-md-5">
                           <select id="ddlDoctor"  tabindex="8"></select>
                       </div>
                        <div class="col-md-3">
                            Is PRN : 
                        </div>
                        <div class="col-md-2">
                               <input type="checkbox"  id="chkIsPRN" />
                        </div>
                       <div class="col-md-3">
                            <input type="button" id="btnAdd" title="Add Item" value="Add Item" class="ItDoseButton" tabindex="9" onclick="AddItem();"  />

                       </div>
                   </div> 
                    <div class="row">

                        <div class="col-md-5">
                            Is Discharge Medicine : 
                        </div>
                        <div class="col-md-3">
                               <input type="checkbox"  id="chkIsDischargeMedicine" />
                        </div>
                    </div>
                    
                    
 </div>

                
                
                   <div id="divOutput" style="max-height: 200px; overflow-y:auto;overflow-x: hidden;">
                           


                               
                                                
<table id="tbOrderSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                               <thead>
    
<tr>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Item Name</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none"">ItemId</th>
 
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center; ">Start Date</th>
 

<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Now</th> 
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Doctors</th>


 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Schedule Dose Time</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Dose</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Interval</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:left">Duration</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Route</th>
     <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Quantity</th>
    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">IS PRN</th>

<th class="GridViewHeaderStyle" scope="col" style="width: 160px; text-align:center">Remarks</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>
 </tr>   
</thead>
<tbody></tbody>                            
</table>





                            </div>
                 </div>
            <div style="text-align:center;display:none" class="POuter_Box_Inventory" id="divSave">
                <input type="button" value="Save" class="save margin-top-on-btn" id="btnSave" onclick="SaveIndent()"/>
            </div>



             <div class="POuter_Box_Inventory">
               <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>   
             </div>
              <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                 Active   Order  Details
                </div>

                <asp:GridView ID="GrdOrder" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="GrdOrder_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ItemName" HeaderText="Medicine Name">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                           <asp:BoundField DataField="Doses" HeaderText="Dose">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                            <asp:BoundField DataField="Route" HeaderText="Route">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Frequency" HeaderText="Frequency" Visible="false">
                            <ItemStyle Width="40px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         
                        <asp:BoundField DataField="StartDate" HeaderText="Start Date">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         

                         <asp:TemplateField HeaderText="Schedule Dose">
                            <ItemTemplate>
                                <%-- <div id="divSchedulehyper" style="color:blue;cursor: pointer;"  onclick='openMissingModel(<%# DataBinder.Eval(Container.DataItem,"ID") %>,<%# DataBinder.Eval(Container.DataItem,"Frequency") %>)' ><%# DataBinder.Eval(Container.DataItem,"ScheduleDose") %></div>
                           --%>
                                <div id="divSchedulehyper" style="color:blue;cursor: pointer;"><%# DataBinder.Eval(Container.DataItem,"ScheduleDose") %></div>
                          
                                
                                 </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                         

                          <asp:BoundField DataField="StartDoseTime" HeaderText="First Dose Time">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>



                        <asp:BoundField DataField="FinalDoseTime" HeaderText="Final Dose Time">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        
                        <asp:BoundField DataField="Remark" HeaderText="Comments">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="CostQty" HeaderText="Cost Of Medicine">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="IndentStatus" HeaderText="Indent Status">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="PrnView" HeaderText="Is PRN">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="OrderBy" HeaderText="Order By">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="Ackstring" HeaderText="Ack By">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="HiddenField" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblID" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblItemId" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemId") %>'
                                    Visible="False"> </asp:Label>

                                <asp:Label ID="lblPatientId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PatientId") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblTransactionId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"TransactionId") %>'
                                    Visible="False"> </asp:Label>

                                 
                                <asp:Label ID="lbldrId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DoctorId") %>'
                                    Visible="False"> </asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="160px" CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                   <div id="divModelDiscontinue"  style= "cursor: pointer;" onclick="DiscontinueOrder( '<%# DataBinder.Eval(Container.DataItem,"Id") %>' )"  ><input type="button" value="DC" style="background-color:red;color:white"/></div>
                           
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                         
                    </Columns>
                </asp:GridView>




            </div>



              <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                 Discontinued   Order  Details
                </div>

                <asp:GridView ID="grdDiscontinued" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdDiscontinued_RowCommand" >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ItemName" HeaderText="Medicine Name">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Doses" HeaderText="Dose">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                            <asp:BoundField DataField="Route" HeaderText="Route">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Frequency" HeaderText="Frequency" Visible="false">
                            <ItemStyle Width="40px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         
                        <asp:BoundField DataField="StartDate" HeaderText="Start Date">
                            <ItemStyle Width="100px" HorizontalAlign="Right" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="StartDoseTime" HeaderText="First Dose Time">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FinalDoseTime" HeaderText="Final Dose Time">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="IndentStatus" HeaderText="Indent Status">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="PrnView" HeaderText="Is PRN">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                         
                        <asp:BoundField DataField="CostQty" HeaderText="Cost Of Medicine">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="OrderBy" HeaderText="Order By">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Ackstring" HeaderText="Ack By">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="HiddenField" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblOrID" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Id") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblItemId" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemId") %>'
                                    Visible="False"> </asp:Label>

                                <asp:Label ID="lblPatientId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PatientId") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblTransactionId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"TransactionId") %>'
                                    Visible="False"> </asp:Label>

                                 
                                <asp:Label ID="lbldrId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DoctorId") %>'
                                    Visible="False"> </asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="160px" CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                   <div id="divModelReorder" class="ItDoseButton" style= "cursor: pointer;" onclick="openReorderModel('<%# DataBinder.Eval(Container.DataItem,"ItemName") %>','<%# DataBinder.Eval(Container.DataItem,"Dose") %>','<%# DataBinder.Eval(Container.DataItem,"DoseUnit") %>','<%# DataBinder.Eval(Container.DataItem,"IntervalId") %>','<%# DataBinder.Eval(Container.DataItem,"IntervalName") %>','<%# DataBinder.Eval(Container.DataItem,"Qty") %>','<%# DataBinder.Eval(Container.DataItem,"Frequency") %>','<%# DataBinder.Eval(Container.DataItem,"DurationVal") %>','<%# DataBinder.Eval(Container.DataItem,"Id") %>','<%# DataBinder.Eval(Container.DataItem,"Route") %>')"  ><input type="button" value="Reorder"/></div>
                           
                                  
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                         
                    </Columns>
                </asp:GridView>




            </div>

        </div>
           
             

 

        <div class="modal fade" id="DoseMissingModel">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeMissingModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Medication Status  Wise</h4>
                         <div class="row">
                            <div class="col-md-1"><input type="button" class="circle" style="background-color:red;height:10px;width:23px" /> </div>
                            <div class="col-md-2">Missed</div>
                             <div class="col-md-1"><input type="button" class="circle" style="background-color:green;height:10px;width:23px" /> </div>
                            <div class="col-md-6">On Time(within 1 Hour)</div>
                             <div class="col-md-1"><input type="button" class="circle" style="background-color:orange;height:10px;width:23px"/></div>
                            <div class="col-md-9">Late(After 1 hour before next time)</div>
                             <div class="col-md-1"><input type="button" class="circle" style="background-color:white;height:10px;width:26px;color:black;border:solid" /></div>
                            <div class="col-md-2">Pending</div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <label id="lblOrderIdMiss" style="display:none"></label>
                            <label id="lblFrequencyMiss" style="display:none"></label>

                            <div class="col-md-3">
                                Date :
                            </div>
                             <div class="col-md-5">
                                <asp:TextBox ID="txtdateMissing" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="calMiss" runat="server" TargetControlID="txtdateMissing" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <input type="button" id="btnSearchMiss" onclick="SearchMissData()" value="Search" />
                            </div>
                        </div>


                        <div class="row" id="DoseMissingData" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                             
                        </div>


                    </div>
                    <div class="modal-footer">
                    </div>
                </div>

            </div>
        </div>



<%--//Reorder  Medicine--%>
        <div class="modal fade" id="divDoseReorder">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 1000px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeReorderModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Medicine Reorder</h4>
                    </div>
                    <div class="modal-body">
                         
                        <div class="row">
                            <div class="col-md-4">
                                Medicine Name : 
                            </div>
                            <div class="col-md-20">
                                  <label id="lblOrderID" style="display:none"></label>                            
                                <label id="lblRMedName"></label>
                            </div>
                        </div>

               <div class="row">
                        <div class="col-md-3">
                            Dose / Unit :
                        </div>
                        <div class="col-md-2">
                             <input type="text" id="txtRDose" style="width:80px" tabindex="6"  class="requiredField ItDoseTextinputNum indentMedicalRequiredField"   onlynumber="9" decimalplace="2" max-value="999" class="requiredField"  />  
                                       
                        </div>
                        <div class="col-md-2">
                             <select id="ddlRUnit" class="requiredField indentMedicalRequiredField"></select>
                                
                        </div>
                        

                     <div class="col-md-2">
                        Interval: 
                    </div>

                      <div class="col-md-3">
                           <select id="ddlMInterval" onchange="Rddlintervalchange();" style="width:80px" tabindex="4" class="requiredField indentMedicalRequiredField" ></select> 
                        <span style="color: red; font-size: 10px;display:none">*</span>
                                                
                    </div>
                         <div class="col-md-2">
                        Duration: 
                    </div>

                      <div class="col-md-2">
                           <select id="ddlMDuration" onchange="calculateMQuantity();" style="width:80px" tabindex="4" class="requiredField indentMedicalRequiredField" ></select> 
                                                     <span style="color: red; font-size: 10px;display:none">*</span>
                                                
                    </div>
                        <div class="col-md-2">
                        Route : 
                        </div>
                        <div class="col-md-2">
                              <select id="ddlMroute" style="width:80px"  tabindex="5"></select>
                        </div>
                        <div class="col-md-2">
                            Qty. :
                        </div>
                        <div class="col-md-1">
                               <input  type="text" id="txtMQty" style="width:50px"  class="requiredField"  tabindex="9"  onlynumber="7" decimalplace="2" max-value="9999"  /> 
                                  
                        </div>
                    </div>
                    <div class="row">
                   

                        <div class="col-md-3">
                            Start Date :&nbsp
                        </div>

                        <div class="col-md-5">
                              <asp:TextBox ID="txtMStartDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtMStartDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                        </div>
                       
                         
                       <div class="col-md-3">
                           Remarks :&nbsp;
                       </div>
                       <div class="col-md-5">
                             <input type="text" id="txtMRemark" class="ItDoseTextinputText"   tabindex="7"   />
                       </div>
                       <div class="col-md-3">
                           Doctor :&nbsp;
                       </div>
                       <div class="col-md-5">
                           <select id="ddlMDoctor"  tabindex="8" disabled="disabled"></select>
                       </div> 
                   </div> 
                    <div class="row">

                        <div class="col-md-5">
                            Is Discharge Medicine :&nbsp;
                        </div>
                        <div class="col-md-3">
                               <input type="checkbox"  id="chkMIsDischarge" />
                        </div>
                   
                       <div class="col-md-2">
                            Times :
                        </div>

                        <div class="col-md-14" >
                              <div class="row" id="divReorderIntervalTimes">
                                   
                              </div>
                              
                        </div>
                  
                        
                        
                        
                         </div>
                    

                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnsReorderSave" value="Save" onclick="SaveReOrderEntry()" />
                    </div>
                </div>

            </div>
        </div>

<%--// Close Reorder Medicine
--%>



    </form>
    <script type="text/javascript">

        var onMedicineSetIndentsModelOpen = function () {
            $('#divMedicineSetAndIndents').showModel();
        }

        var onMedicineSetIndentsModelClose = function () {
            $('#divMedicineSetAndIndents').closeModel();
        }


        function chkMedicineType() {
            if ($("#rdoset").is(":checked")) {
                $('#ddlMedicineset').val(0).removeAttr('disabled');
                $('#PatientMedicineSearchOutput').html("");
                LoadMedicineSet();

            }
            else if ($("#rdoIndent").is(":checked")) {
                $('#ddlMedicineset').val(0).removeAttr('disabled');
                $('#PatientMedicineSearchOutput').html("");
                IndentMedicine();
            }

        }
        function IndentMedicine() {
            $('#ddlMedicineset option').remove();
            var TID = $('#spnTransactionID').text();
            $.ajax({
                url: "Doctoer_Medicine_Order.aspx/LoadIndentMedicine",
                data: '{TnxID:"' + TID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charst=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    $('#ddlMedicineset option').remove();
                    if (data != null) {
                        $("#ddlMedicineset").append($("<option></option>").val("0").html("Select"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlMedicineset').append($("<option></option>").val(data[i].id).html(data[i].dtEntry));
                        }
                    }
                }

            });
        }
        function LoadMedicineSet() {
            jQuery("#ddlMedicineset option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/LoadMedicineSet",
                data: '{DoctorID:""}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        $("#ddlMedicineset").append($("<option></option>").val("0").html("Select"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlMedicineset').append($("<option></option>").val(data[i].ID).html(data[i].SetName));
                        }
                    }
                }
            });
        }
        function LoadMedSetItems() {
            if ($("#rdoset").is(":checked")) {
                $.ajax({
                    type: "POST",
                    data: '{SetID:"' + $('#ddlMedicineset').val() + '"}',
                    url: "../Common/CommonService.asmx/LoadMedSetItems",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != null) {
                            var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                            $('#PatientMedicineSearchOutput').html(output);
                            $('#PatientMedicineSearchOutput').show();
                            $('#btnSaveSet').show();
                            $("#Table1 tr").each(function () {
                                var id = $(this).attr("id");
                                var $rowid = $(this).closest("tr");
                                if (id != "Header") {
                                    var Sno = $rowid.find("#tdSno").text();
                                    var ddlSetTime = $rowid.find('#ddlSetTime' + Sno);
                                    var ddlSetDuration = $rowid.find('#ddlSetDuration' + Sno);
                                    var ddlRoute1 = $rowid.find('#ddlRoute1' + Sno);
                                    bindtime(ddlSetTime);
                                    bindDuration(ddlSetDuration);
                                    bindRoute(ddlRoute1);
                                    if ($(this).find('#spnTimes').html() != "") {
                                        $(this).find('#ddlSetTime' + Sno).val($(this).find('#spnTimes').html());
                                    }
                                    if ($(this).find('#spnduration').html() != "") {
                                        $(this).find('#ddlSetDuration' + Sno).val($(this).find('#spnduration').html());
                                    }
                                    if ($(this).find('#spnroute').html() != "") {
                                        $(this).find('#ddlRoute1' + Sno).val($(this).find('#spnroute').html());
                                    }
                                    if ($(this).find('#spnMeal').html() != "") {
                                        $(this).find('#ddlMeal' + Sno).val($(this).find('#spnMeal').html());
                                    }
                                }
                            });
                            //  BindDropdown();
                        }
                        else {
                            $('#PatientMedicineSearchOutput').html();
                            $('#PatientMedicineSearchOutput').hide();
                            $('#btnSaveSet').hide();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#debugArea").html("");
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }

                });
            }
            else if ($("#rdoIndent").is(":checked")) {
                $.ajax({
                    url: "Doctoer_Medicine_Order.aspx/LoadIndentItems",
                    data: '{IndentNo:"' + $('#ddlMedicineset').val() + '"}',
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != null) {
                            var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                            $('#PatientMedicineSearchOutput').html(output);
                            $('#PatientMedicineSearchOutput').show();
                            $('#btnSaveSet').show();
                            $("#Table1 tr").each(function () {
                                var id = $(this).attr("id");
                                var $rowid = $(this).closest("tr");
                                if (id != "Header") {
                                    var Sno = $rowid.find("#tdSno").text();
                                    var ddlSetTime = $rowid.find('#ddlSetTime' + Sno);
                                    var ddlSetDuration = $rowid.find('#ddlSetDuration' + Sno);
                                    var ddlRoute = $rowid.find('#ddlRoute1' + Sno);
                                    bindtime(ddlSetTime)
                                    bindDuration(ddlSetDuration)
                                    bindRoute(ddlRoute);
                                }
                            });
                            // BindDropdown();
                        }
                        else {
                            $('#PatientMedicineSearchOutput').html();
                            $('#PatientMedicineSearchOutput').hide();
                            $('#btnSaveSet').hide();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#debugArea").html("");
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
        }
        function bindtime(ddlSetTime) {
            var Type = "Time";
            $.ajax({
                type: "POST",
                url: "../Common/CommonService.asmx/getTimeDuration",
                data: '{Type:"' + Type + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Tim = jQuery.parseJSON(result.d);
                    if (Tim != null) {
                        ddlSetTime.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Tim.length; i++) {
                            ddlSetTime.append($("<option></option>").val(Tim[i].Quantity + '#' + Tim[i].NAME).html(Tim[i].NAME));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function bindDuration(ddlSetDuration) {
            var Type = "Duration";
            $.ajax({
                type: "POST",
                url: "../Common/CommonService.asmx/getTimeDuration",
                data: '{Type:"' + Type + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Dur = jQuery.parseJSON(result.d);
                    if (Dur != null) {
                        ddlSetDuration.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            ddlSetDuration.append($("<option></option>").val(Dur[i].Quantity + '#' + Dur[i].NAME).html(Dur[i].NAME));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function bindRoute(ddlRoute) {
            $.ajax({
                type: "POST",
                url: "Doctoer_Medicine_Order.aspx/BindRoute",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    Route = jQuery.parseJSON(result.d);
                    if (Route != null) {
                        ddlRoute.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Route.length; i++) {
                            ddlRoute.append($("<option></option>").val(Route[i]).html(Route[i]));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
    </script>
     <script id="tb_PatientMedicineSearch" type="text/html">
  <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%; border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col">#</th>
                <th class="GridViewHeaderStyle" scope="col"></th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none" >itemID</th>
                <th class="GridViewHeaderStyle" scope="col">Medicine name</th>
                <th class="GridViewHeaderStyle" scope="col">Quantity</th>
                <th class="GridViewHeaderStyle" scope="col">Dose</th>
                <th class="GridViewHeaderStyle" scope="col">Time</th>
                <th class="GridViewHeaderStyle" scope="col">Duration</th>
                <th class="GridViewHeaderStyle" scope="col">Route</th>
                <th class="GridViewHeaderStyle" scope="col">Meal</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">UnitType</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">Medicine Type</th>
                
            </tr>

            <#
       
            var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

            objRow = PatientData[j];
        
          #>
                    <tr id="<#=j+1#>" >
                        <td class="GridViewLabItemStyle" id="tdSno" ><#=j+1#></td>
                        <td class="GridViewLabItemStyle" ><input type="checkbox" id="chkSelect" checked="checked" /></td>
                        <td id="tdItemID" class="GridViewLabItemStyle" style="display:none;"><#=objRow.ItemID#></td>
                        <td  id="tdItemName" class="GridViewLabItemStyle" ><#=objRow.NAME#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;"><input  type="text" class="ItDoseTextinputText" id="txtQtySet"  value="<#=objRow.quantity#>" style="width:70px" /></td>
                        <td id="tdDose" class="GridViewLabItemStyle" ><input  type="text" class="ItDoseTextinputText" id="txtsetDose" style="width:70px" value="<#=objRow.Dose#>" /></td>
                        <td id="tdTime" class="GridViewLabItemStyle" ><span id="spnTimes" style="display:none"><#=objRow.times#></span> <select id="ddlSetTime<#=j+1#>" style="width:120px" onchange="calculateLPopupQty();"> </select></td>
                        <td id="tdduration" class="GridViewLabItemStyle"><span id="spnduration" style="display:none"><#=objRow.Duration#></span>  <select id="ddlSetDuration<#=j+1#>"  clientidmode="Static" style="width:120px" onchange="calculateLPopupQty();"> </select>  </td>
                        <td id="tdroute1" class="GridViewLabItemStyle"> 
                            <span id="spnroute" style="display:none"><#=objRow.Route#></span>
                            <select id="ddlRoute1<#=j+1#>" ></select>
                        </td>
                        <td id="tdMeal" class="GridViewLabItemStyle"> 
                            <span id="spnMeal" style="display:none"><#=objRow.Meal#></span>
                            <select id="ddlMeal<#=j+1#>" clientidmode="Static" style="width:100px">
                                <option value="0">Select</option>
                                <option value="After Meal">After Meal</option>
                                <option value="Before Meal">Before Meal</option>
                            </select>
                        </td>
                        <td id="tdunittype" class="GridViewLabItemStyle" style="display:none;"><#=objRow.unittype#></td>   
                        <td id="tdMedicineType" class="GridViewLabItemStyle" style="display:none;"><#=objRow.MedicineType#></td>   
                </tr>
           <#}#>
     </table>    
    </script>
     <script id="sc_Deptstock" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblDeptStock" style="border-collapse:collapse;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Dept. Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px">Quantity</th>
            </tr>
            <#
  var dataLength=DeptLedStock.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = DeptLedStock[j];
          #>
                    <tr id="Tr4" >
                     
                        <td class="GridViewLabItemStyle" style="display:none"><#=j+1#></td>
                        <td id="tdDeptName" class="GridViewLabItemStyle" style="width: 100px;"><#=objRow.DeptName#></td>
                        <td id="tdDeptQuantity" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.Quantity#></td>
                </tr>
            <#}#>
     </table>    
    </script>
    <script type="text/javascript">
        function AddItem() {

            if ($("#pharmacyItem").combogrid('getValue') == "") {
                modelAlert('Please Select Item')
                return false;
            }
            $("#btnAddInv").attr('disabled', 'disabled');
            $("#spnErrorMsg").text('');
            if ($("#pharmacyItem").combogrid('getValue') === null || $("#pharmacyItem").combogrid('getValue') === undefined) {
                modelAlert('Please Select Item', function () {
                    $("#btnAddInv").removeAttr('disabled');
                    return false;
                });
            }

            var ItemID = $("#pharmacyItem").combogrid('getValue').split('#')[0];
            var categoryID = $("#pharmacyItem").combogrid('getValue').split('#')[9];
            var conDup = 0;
            var UserName = "";
            var Date = "";
            var RowColour = "";

            alreadyPrescribeOrderItem({ PatientID: $.trim($('#spnPatientID').text()), ItemID: ItemID }, function (response) {
                if (response) {
                    if (CheckOrderDuplicateItem(ItemID)) {
                        modelAlert('Selected Item Already Added');
                        conDup = 1;
                        $("#btnAddInv").removeAttr('disabled');
                        $('#pharmacyItem').combogrid('reset');
                        $("#pharmacyItem").combogrid('clear');
                        $('#pharmacyItem').next().find('input').focus();
                        return;
                    }
                    if (conDup == "1") {
                        modelAlert('Selected Item Already Added');
                        return;
                    }

                    var Time, Duration, Route, DurationValue, Meal;
                    var ItemName = $("#pharmacyItem").combogrid('getText');
                    var ItemCode = $("#pharmacyItem").combogrid('getValue').split('#')[8];
                    var SubCategoryID = $("#pharmacyItem").combogrid('getValue').split('#')[1];
                    var Dose = $('#txtDose').val(); // Number($('#txtDose').val());
                    var DoseUnit = $('#txtUnit').val();

                    if ($('#ddlDuration').val() != "0") {
                        Duration = $('#ddlDuration option:selected').text();
                        DurationValue = $('#ddlDuration option:selected').val();
                    }
                    else {
                        Duration = "";
                        DurationValue = 0;
                    }
                    if ($('#ddlRoute').val() != "0")
                        Route = $('#ddlRoute option:selected').text();
                    else
                        Route = "";


                    if (Route == "0" || Route == "" || Route == undefined || Route==null) {
                        modelAlert('Please Select Route.', function () {
                             
                        });
                        return false;
                    }



                    if (Dose <= 0) {
                        modelAlert('Please Enter Dose.', function () {
                            $('#txtDose').focus();
                        });
                        return false;
                    }



                    if (Duration == '') {
                        modelAlert('Please Select Duration.', function () {
                            $('#ddlDuration').focus();
                        });
                        return false;
                    }
                    if ($('#ddlRoute').val() == '0')
                    {
                        modelAlert('Please Enter Route.', function () {
                            $('#ddlRoute').focus();
                        });
                        return false;
                    }
                    if ($('#ddlInterval').val() == '0') {
                        modelAlert('Please Enter Interval.', function () {
                            $('#ddlInterval').focus();
                        });
                        return false;
                    }


                    var Quantity = Number($('#txtRequestedQty').val());
                    if (Quantity <= 0) {
                        modelAlert("Please Enter Valid Quantity", function () {
                            $('#txtRequestedQty').focus();
                        });

                        return false;
                    }



                    var TID = $("#spnTransactionID").text();

                    var isNow = $('#chkIsNow').is(":checked");
                    var SelectedDate = $('#txtSelectDate').val();

                    var txtFirstDose = $("#txtfirstDose").val();

                    var PatientDoseTime = "";
                    var PatientDoseTimeDis = "";
                    var count = 0;
                    $('.txtPDoseTime').each(function () {
                        if (count==0) {
                            PatientDoseTime += this.value;
                            PatientDoseTimeDis += this.value;
                        }
                        else {
                            PatientDoseTime += "#" + this.value;
                            PatientDoseTimeDis += "," + this.value;
                        }
                        count = count + 1;
                    });


                    var txtRemarks = $("#txtRemarks").val();

                    var ddlDoctor = $("#ddlDoctor").val();
                    var ddlDoctorName = $("#ddlDoctor option:selected").text();

                    var IsPrn = 0;
                    var IsPrnShow ="NO";
                    
                    if ($('#chkIsPRN').is(':checked')) {
                        IsPrn = 1;
                        IsPrnShow="YES"
                    }

                    var Interval = $('#ddlInterval').val().split('#')[0]
                    var IntervalText = $("#ddlInterval :selected").text();

                    $('#tbOrderSelected').css('display', 'block');


                    $('#tbOrderSelected tbody').append('<tr><td class="GridViewLabItemStyle" style="width:120px;"><span id="tdItemName">' + ItemName + '</span> </td>' +
                                            '<td class="GridViewLabItemStyle" style="text-align:center; display:none"><span id="tditemID" >' + ItemID + '</span></td>' +
                                               '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtSelectDate" style="">' + SelectedDate + '</span> </td>' +
                                            '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtfirstdose" style="">' + txtFirstDose + '</span> <span id="tdIsNow" style="display:none">' + isNow + '</span> </td>' +


                                       '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlDoctor" >' + ddlDoctor + '</span> </td>' +
                                        '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdddlDoctorName" style="">' + ddlDoctorName + '</span> </td>' +
                                          '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="tdDoseTime">' + PatientDoseTime +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px;" ><span id="tdScheduleDisp">' + PatientDoseTimeDis +

                                        
                                         '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="tdspnDose">' + Dose +
                                         '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="tdspnDoseUnit">' + DoseUnit +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdDoseUnit">' + Dose + '  ' + DoseUnit +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="tdspnIntervalId">' + Interval +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnIntervalText">' + IntervalText +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnDuration">' + Duration +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="tdspnDurationValue">' + DurationValue +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnRoute">' + Route +

                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdspnQuantity">' + Quantity + '</span> </td>' +

                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdIsPrn" style="width:120px;display:none" >' + IsPrn + '</span><span id="tdIsPrnShow">' + IsPrnShow + '</span>  </td>' +


                    '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtRemarks" style="">' + txtRemarks + '</span> </td>' +




                '<td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');




                    $("#btnAddInv").removeAttr('disabled');
                    $('#tbSelected').hide();
                    $('#LabOutput,#tbOrderSelected').show();
                    $('#txtRemarks').val('');

                    $('#txtDose').val('');

                    $('#ddlDuration').val('0');
                    $('#ddlRoute').val('0');

                    $('#divSave').show();
                    $("#spnErrorMsg").text('');
                    $('#pharmacyItem').combogrid('reset');
                    $("#pharmacyItem").combogrid('clear');
                    $('#pharmacyItem').next().find('input').focus();
                    $('.textbox-text').focus();


                }
            });



        }
        function CheckDuplicateItem(ItemID) {
            var count = 0;
            $('#tbSelected tr:not(#Header)').each(function () {
                var item = $(this).find('#spnitemID').text().trim();
                if ($(this).find('#spnitemID').text().trim() == ItemID) {
                    count = count + 1;
                }
            });
            if (count == 0)
                return false;
            else
                return true;
        }
        function RemoveRows(rowid) {
            $(rowid).closest('tr').remove();
            if ($('#tbSelected tr:not(#Header)').length == 0) {
                $('#tbSelected').hide();
                $('#divSave').hide();
            }
            $("#spnErrorMsg").text('');
        }
        function alreadyPrescribeItem(ItemID) {
            if ($.trim($('#spnPatientID').text()) != "") {
                var prescribeItem = 0;
                $.ajax({
                    url: "../IPD/Services/IPDLabPrescription.asmx/getAlreadyPrescribeItem",
                    data: '{PatientID:"' + $.trim($('#spnPatientID').text()) + '",ItemID:"' + ItemID + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var prescribeData = jQuery.parseJSON(mydata.d);
                        if (prescribeData != null && prescribeData != "") {
                            if (confirm('This Medicine is Already Prescribed By ' + prescribeData[0].UserName + ' Date On ' + prescribeData[0].EntryDate + '. Do You Want To Prescribe Again ???')) {
                                prescribeItem = 0;
                            }
                            else {
                                prescribeItem = 1;
                            }
                        }
                        else
                            prescribeItem = 0;

                    }
                });
            }
            return prescribeItem;
        }
        function validatedot() {
            if (($("#txtRequestedQty").val().charAt(0) == ".")) {
                $("#txtRequestedQty").val('');
                return false;
            }

            return true;
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 13) {
                    e.preventDefault();
                    //        AddItem();
                }
            }

            return true;
        }
        var bindAdmissionDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../IPD/Services/IPDAdmission.asmx/bindAdmissionDoctor', { defaultvalue: {} }, function (response) {
                $ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }
        function AddSetItem() {

            if ($("#ddlMedicineset").val() != "0") {
                jQuery("#Table1 tr").each(function (i) {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Tr1") {
                        if ($(this).find("#chkSelect").is(":checked")) {
                            var ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                            var conDup = 0;
                            var AlreadyPreItem = 0;
                            var prescribeItem = 0;
                            var UserName = "";
                            var Date = "";
                            var RowColour = "";
                            prescribeItem = alreadyPrescribeItem(ItemID);
                            if (prescribeItem == 0) {
                                if (CheckDuplicateItem(ItemID)) {
                                    $("#spnErrorMsg").text('Selected Item Already Added');
                                    conDup = 1;
                                    $("#btnAddInv").removeAttr('disabled');
                                    //$('#txtSearch').focus();
                                    return;
                                }
                                if (conDup == "1") {
                                    $("#spnErrorMsg").text('Selected Item Already Added');
                                    //$('#txtSearch').focus();
                                    return;
                                }
                                var Sno = jQuery.trim($rowid.find("#tdSno").text());
                                var ItemName = jQuery.trim($rowid.find("#tdItemName").text());
                                var Quantity = jQuery.trim($rowid.find("#txtQtySet").val());
                                if (Quantity == '0' || Quantity == 'undefined' || Quantity == '')
                                    Quantity = "";
                                var Dose = jQuery.trim($rowid.find("#txtsetDose").val());
                                if (Dose == "" || Dose == 'undefined')
                                    Dose = "";
                                var Time = jQuery.trim($rowid.find('#ddlSetTime' + Sno).val());
                                if (Time == '0' || Time == undefined || Time == '')
                                    Time = "";
                                var Duration = jQuery.trim($rowid.find('#ddlSetDuration' + Sno).val());
                                if (Duration == undefined || Duration == '0' || Duration == '')
                                    Duration = "";
                                var Route = jQuery.trim($rowid.find('#ddlRoute1' + Sno).val());
                                if (Route == '0' || Route == 'undefined' || Route == '')
                                    Route = "";
                                var Meal = jQuery.trim($rowid.find('#ddlMeal' + Sno).val());
                                if (Meal == '0' || Meal == 'undefined' || Meal == '')
                                    Meal = "";
                                $('#tbSelected').css('display', 'block');
                                var ItemCode = "", Remarks = "", SubCategoryID = "";
                                var unitType = jQuery.trim($rowid.find('#tdunittype').text());
                                $('#tbSelected').append('<tr ' + RowColour + '><td class="GridViewLabItemStyle"  ><span id="ItemCode">' + ItemCode +
                                                        '</span></td><td class="GridViewLabItemStyle" ><span id="spnItemName">' + ItemName +
                                                        '</span><span id="spnSubCategoryID"  style="display:none" > ' + SubCategoryID + ' </span><span id="spnitemID" style="display:none" >' + ItemID +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnDose">' + Dose +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnTime">' + Time +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnDuration">' + Duration +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnRoute">' + Route +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnMeal">' + Meal +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnQuantity">' + Quantity +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnRemarks">' + Remarks +
                                                        '</span><span id="spnunitType" style="display:none">' + unitType + '</span></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td>');
                            }
                        }
                    }
                });
                $('#divSave').show();
                onMedicineSetIndentsModelClose();
            }
        }
        function SaveIndent() {

            SaveOrderEntry(function () { });

        }
        function ClearControls() {
            $("#tbSelected tr:not(#Header)").remove();
            $('#tbSelected').removeAttr('disabled').hide();
            $('#divSave').hide();
            $('#btnSave').removeAttr('disabled');
            bindAdmissionDoctor(function () {

            });
        }
        function AddInvestigation(sender, e) {
            var key = (e.keyCode ? e.keyCode : e.charCode);
            // alert(key);
            if (e.which == "")
                e.preventDefault();
            if ((e.which == 13)) {
                e.preventDefault();
                AddItem();
            }
            validatedot();
        }
        function EnterQuantity(sender, e) {
            var key = (e.keyCode ? e.keyCode : e.charCode);
            // alert(key);
            if (e.which == "")
                e.preventDefault();
            if ((e.which == 13)) {
                e.preventDefault();
                $('#txtRequestedQty').focus();
            }

        }
    </script>


    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css"> 
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
  
    <script type="text/javascript">
        $(function () {
            HideShow(0);
            $('.textbox-text').bind("keyup", function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    $('#txtRequestedQty').focus();
                }
                if (code == 9) {
                    $('#pharmacyItem').next().find('table').find('tr').find('td').find('input').focus();
                }
            });
            $('#txtRequestedQty').bind("keyup", function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                //alert(code);
                if (code == 13) {
                    $('.textbox-text').focus();
                    AddItem();
                }
                if (code == 9) {
                    $('.textbox-text').focus();
                    AddItem();
                }
            });
            $('#pharmacyItem').next().find('input').focus();
            $('#txtRequestedQty').removeAttr('tabIndex').attr('tabIndex', '2');
            //$('#ddlMedicineset').chosen();
            BindRequisitionType();
            BindSubcategory();
            BindDurationForm();

            BindRouteForm();
            BindInterVal();
            BindUnit();

            RBindInterVal();
            RBindUnit();
            RBindRouteForm();
            RBindDurationForm();

            RbindAdmissionDoctor(function () {
                BindPatientDetail();
            });

           
            HideShow(0);
            
            LoadMedicineSet();
            bindAdmissionDoctor(function () {
                BindPatientDetail();
            });
        });
        function QuantityCal() {
            var Time = $('#ddlInterval').val().split('#')[1];
            var Duration = $('#ddlDuration').val();
            alert(Time);
            var MedicineType = $("#pharmacyItem").combogrid('getValue').split('#')[7].trim();
            var Quantity = 0;
            //alert(MedicineType);
            if (MedicineType == "tablet" || MedicineType == "capsule") {
                Quantity = Time * Duration;
                if (Quantity != 0 && Quantity != NaN)
                    $('#txtRequestedQty').val(Quantity);
                else
                    $('#txtRequestedQty').val('1');
            }
            else if (MedicineType == "Syrup" || MedicineType == "EyeDrop" || MedicineType == "EarDrop" || MedicineType == "NosalDrop" || MedicineType == "Tube"
                || MedicineType == "Lotion" || MedicineType == "Cream" || MedicineType == "Injection" || MedicineType == "Inhaler"
                ) {
                $('#txtRequestedQty').val('1');
            }
            else {
                $('#txtRequestedQty').val('');
            }
        }




        var BindDurationForm = function () {
            serverCall('../Common/CommonService.asmx/getTimeDuration', { Type: 'Duration' }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlDuration').bindDropDown({
                    data: responseData,
                    valueField: 'Quantity',
                    textField: 'NAME',
                    defaultValue: 'Select',
                });
            });
        }

        function BindRouteForm() {
            $.ajax({
                type: "POST",
                url: "Doctoer_Medicine_Order.aspx/BindRoute",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Rou = jQuery.parseJSON(result.d);
                    if (Rou != null) {
                        $('#ddlRoute').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Rou.length; i++) {
                            $('#ddlRoute').append($("<option></option>").val(Rou[i]).html(Rou[i]));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function BindRequisitionType() {
            var ddlRequisitionType = $('#ddlRequisitionType');
            $('#ddlRequisitionType option').remove();
            $.ajax({
                type: "POST",
                url: "Doctoer_Medicine_Order.aspx/BindRequisitionType",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Dur = jQuery.parseJSON(result.d);
                    if (Dur != null) {
                        ddlRequisitionType.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            ddlRequisitionType.append($("<option></option>").val(Dur[i].TypeID).html(Dur[i].TypeName));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function BindSubcategory() {
            $('#ddlSubCategory option').remove();
            $.ajax({
                type: "POST",
                url: "Doctoer_Medicine_Order.aspx/BindSubcategory",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Dur = jQuery.parseJSON(result.d);
                    if (Dur != null) {
                        $('#ddlSubCategory').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            $('#ddlSubCategory').append($("<option></option>").val(Dur[i].SubCategoryID).html(Dur[i].Name));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }







        function BindPatientDetail() {
            jQuery.ajax({
                url: "../IPD/Services/IPDLabPrescription.asmx/BindPatientDetails",
                data: '{TID:"' + $('#spnTransactionID').text() + '",PID:"' + $('#spnPatientID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data != "") {
                        // alert(data[0].DoctorID);
                        $('#ddlDoctor').val(data[0].DoctorID).chosen('destroy').chosen();
                        $('#ddlMDoctor').val(data[0].DoctorID).chosen('destroy');

                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        //################## Order  Section ################

            function isNumber(evt) {
                evt = (evt) ? evt : window.event;
                var charCode = (evt.which) ? evt.which : evt.keyCode;
                if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
                return true;
            }




            function GetOrderDetails() {
                var dataLTD = new Array();
                var objLTD = new Object();
                $("#tbOrderSelected tbody tr").each(function () {

                    var $rowid = $(this).closest("tr");
                     
                    objLTD.ItemId = $.trim($rowid.find("#tditemID").text());
                    objLTD.Qty = $.trim($rowid.find("#tdspnQuantity").text());
                    objLTD.ItemName = $.trim($rowid.find("#tdItemName").text());
                    objLTD.TransactionId = $('#spnTransactionID').text();
                    objLTD.PatientId = $('#spnPatientID').text();

                objLTD.DoctorId = $.trim($rowid.find("#tdddlDoctor").text());
                objLTD.DoctorName = $.trim($rowid.find("#tdddlDoctorName").text());

                objLTD.StartDate = $.trim($rowid.find("#tdtxtSelectDate").text());
                objLTD.Remark = $.trim($rowid.find("#tdtxtRemarks").text());
                objLTD.Dose = $.trim($rowid.find("#tdspnDose").text());
                objLTD.DoseUnit = $.trim($rowid.find("#tdspnDoseUnit").text());

                objLTD.IntervalId = $.trim($rowid.find("#tdspnIntervalId").text());
                objLTD.IntervalName = $.trim($rowid.find("#tdspnIntervalText").text());

                objLTD.IsNow = $.trim($rowid.find("#tdIsNow").text());
                objLTD.FirstDose = $.trim($rowid.find("#tdtxtfirstdose").text());
                objLTD.DurationName = $.trim($rowid.find("#tdspnDuration").text());
                objLTD.DurationVal = $.trim($rowid.find("#tdspnDurationValue").text());
                objLTD.Route = $.trim($rowid.find("#tdspnRoute").text());

                objLTD.IsDischargeMed = ($('#chkIsDischargeMedicine').prop('checked') ? 1 : 0);
                objLTD.TypeOfMedicine = 0;
                objLTD.DepartmentId = $("#ddlDepartment").val();
                objLTD.DoseTime = $.trim($rowid.find("#tdScheduleDisp").text());  
                objLTD.IsPrn = $.trim($rowid.find("#tdIsPrn").text());  

                dataLTD.push(objLTD);
                objLTD = new Object();


            });
            return dataLTD;
        }

            var SaveOrderEntry = function () {
                var resultLTD = GetOrderDetails();

                $('#btnSave').attr('disabled', true).val("Submitting...");



                $.ajax({
                    url: "Doctoer_Medicine_Order.aspx/SaveMedicneOrder",
                    data: JSON.stringify({ Data: resultLTD }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    async: false,
                    dataType: "json",
                    success: function (result) {

                        var responseData = JSON.parse(result.d);
                        var btnSave = $('#btnSave');

                        modelAlert(responseData.response, function () {

                            if (responseData.status)
                                window.location.reload();
                            else
                                $(btnSave).removeAttr('disabled').val('Save');

                        });



                    }
                });

            }




            var alreadyPrescribeOrderItem = function (data, callBack) {
                if (data.PatientID.trim() != '') {
                    serverCall('../IPD/Services/IPDLabPrescription.asmx/getAlreadyPrescribeOrderItem', data, function (response) {
                        responseData = JSON.parse(response);
                        if (responseData != null && responseData != "") {
                            modelConfirmation('Do You Want To Prescribe Again  ?', 'This medicine is already prescribed  </br> On Date  ' + responseData[0].EntryDate, 'Prescribe Again', 'Cancel', function (response) {
                                if (response)
                                    callBack(response);
                            });
                        }
                        else
                            callBack(true);
                    });
                }
                else
                    callBack(true);
            }

            function CheckOrderDuplicateItem(ItemID) {
                var count = 0;
                $('#tbOrderSelected tbody tr').each(function () {
                    var item = $(this).find('#tditemID').text().trim();
                    if ($(this).find('#tditemID').text().trim() == ItemID) {
                        count = count + 1;
                    }
                });
                if (count == 0)
                    return false;
                else
                    return true;
            }

            //################## Order  Section  End ################
    </script>
    <script type="text/javascript">

        var BindInterVal = function () {
            serverCall('Doctoer_Medicine_Order.aspx/GetInterval', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlInterval').bindDropDown({
                    data: responseData,
                    valueField: 'IdTimes',
                    textField: 'Name',
                    isSearchAble: true,
                    defaultValue: 'Select'

                });
            });
        }

        var BindUnit = function () {
            serverCall('Doctoer_Medicine_Order.aspx/GetUnit', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#txtUnit').bindDropDown({
                    data: responseData,
                    valueField: 'Name',
                    textField: 'Name',
                    isSearchAble: true,
                    //defaultValue: 'Select'

                });
            });
        }

        function HideShow(Type) {
            if (Type == 1) {

                //var minutesToAdd = 0;
                //var currentDate = new Date();
                //var futureDate = new Date(currentDate.getTime() + minutesToAdd * 60000);
                //var now = futureDate;
                //var hours = now.getHours();
                //var minutes = now.getMinutes();
                //var ampm = hours >= 12 ? 'pm' : 'am';
                //hours = hours % 12;
                //hours = hours ? hours : 12;
                //minutes = minutes < 10 ? '0' + minutes : minutes;
                //var timewithampm = hours + ':' + (minutes) + ' ' + ampm;
                 
                serverCall('Doctoer_Medicine_Order.aspx/GetNowTime', {}, function (response) {
                    var responseData = JSON.parse(response);
                    $("#txtfirstDose").val(responseData.time)
                });
                 
                $('.hidefirstDose').show();
            } else {
                $("#txtfirstDose").val("")
                $('.hidefirstDose').hide();
            }

        }


        function GetNow() {
            if ($('#chkIsNow').is(":checked")) {
                HideShow(1);
            } else {
                HideShow(0);
            }

        }


        function ddlintervalchange() {

            var id = $('#ddlInterval').val().split('#')[0];
            BindTimeLabel(id);
            calculateQuantity();

        }

        function BindTimeLabel(Id) {



            serverCall('Doctoer_Medicine_Order.aspx/GetIntervalTimes', { Id: Id }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#divBindTimesLabel').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<div class="col-md-6" style="color: blue;font-weight: bolder;">';
                        rdb += ' <input type="text" id="txtTime' + i + '" class="ItDoseTextinputText txtPDoseTime required" value="' + item.TimeLable + '"  />';
                        rdb += '</div>';
                         
                        $('#divBindTimesLabel').append(rdb);
                    });

                    $('.txtPDoseTime').timepicker({
                        timeFormat: 'h:mm p',
                        interval: 10,
                        minTime: '00:01',
                        maxTime: '11:59pm',
                       // defaultTime: new Date(),
                        startTime: '00:01',
                        dynamic: false,
                        dropdown: true,
                        scrollbar: true
                    });

                } else {
                    $('#divBindTimesLabel').empty();
                }

            });



        }
    </script>

    
    <script type="text/javascript">

        var openMissingModel = function (Orid, Frequency) {

            
            GetMissingData(Orid, '', Frequency)
            $("#lblOrderIdMiss").text(Orid);
            $("#lblFrequencyMiss").text(Frequency);
            $("#DoseMissingModel").showModel();
        }

        var $closeMissingModel = function () {
            $('#tblMedicationGiven tbody').empty();
            $("#DoseMissingModel").hideModel();

        }




        function SearchMissData() {


            GetMissingData($("#lblOrderIdMiss").text(), $("#txtdateMissing").val(), $("#lblFrequencyMiss").text())
        }

        function GetMissingData(Id, Date, Freq) {

            serverCall('../IPD/ViewMedicationOrder.aspx/GetMissingData', { OrderId: Id, Date: Date, Frequency: Freq }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    data = GetData.data;
                    $('#DoseMissingData').empty();

                    $('#DoseMissingData').append(data);

                }

                $('#DoseMissingData').show();

            });
        }

    </script>


    <script type="text/javascript">

        var RBindInterVal = function () {
            serverCall('Doctoer_Medicine_Order.aspx/GetInterval', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlMInterval').bindDropDown({
                    data: responseData,
                    valueField: 'IdTimes',
                    textField: 'Name',
                    isSearchAble: true,
                    defaultValue: 'Select'

                });
            });
        }

        var RBindUnit = function () {
            serverCall('Doctoer_Medicine_Order.aspx/GetUnit', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlRUnit').bindDropDown({
                    data: responseData,
                    valueField: 'Name',
                    textField: 'Name',
                    isSearchAble: true,
                    //defaultValue: 'Select'

                });
            });
        }

        var RbindAdmissionDoctor = function (callback) {
            var $ddlDoctor = $('#ddlMDoctor');
            serverCall('../IPD/Services/IPDAdmission.asmx/bindAdmissionDoctor', { defaultvalue: {} }, function (response) {
                $ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }



        var RBindDurationForm = function () {
            serverCall('../Common/CommonService.asmx/getTimeDuration', { Type: 'Duration' }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlMDuration').bindDropDown({
                    data: responseData,
                    valueField: 'Quantity',
                    textField: 'NAME',
                    defaultValue: 'Select',
                });
            });
        }

        function RBindRouteForm() {
            $.ajax({
                type: "POST",
                url: "Doctoer_Medicine_Order.aspx/BindRoute",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Rou = jQuery.parseJSON(result.d);
                    if (Rou != null) {
                        $('#ddlMroute').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Rou.length; i++) {
                            $('#ddlMroute').append($("<option></option>").val(Rou[i]).html(Rou[i]));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        var calculateMQuantity = function () {


            // var dose = Number($('#txtDose').val());
            var times = Number($('#ddlMInterval').val().split('#')[1]);
            var duratation = Number($('#ddlMDuration').val());

            var quantity = precise_round((times * duratation), 2);
            $('#txtMQty').val(quantity);
        }




        var openReorderModel = function (ItemName, Dose, Unit, IntervalId, IntrevalName, Qty, Frequency, DurationVal, OrderID, Route) {

            var times = (24 / Frequency);
            var Intervalnewval = IntervalId + "#" + times;

            $("#lblOrderID").text(OrderID);
            $("#lblRMedName").text(ItemName);

            $("#txtRDose").val(Dose);
            $('#ddlRUnit').val(Unit).chosen('destroy');

            $("#ddlMDuration").val(DurationVal);

            $("#ddlMInterval").val(Intervalnewval).chosen('destroy');
            $('#ddlMroute').val(Route);

            calculateMQuantity();
            BindReorderTimeLabel(IntervalId)
            $("#divDoseReorder").showModel();
        }

        var $closeReorderModel = function () {
            $("#divDoseReorder").hideModel();
            

        }




        function GetReOrderDetails() {
             
            var PatientReDoseTimeDis = "";
            var count = 0;
            $('.txtModelDoseTime').each(function () {
                if (count == 0) {
                  
                    PatientReDoseTimeDis += this.value;
                }
                else {
                     
                    PatientReDoseTimeDis += "," + this.value;
                }
                count = count + 1;
            });

            var objLTD = new Object();

            objLTD.Id = $("#lblOrderID").text()
            objLTD.Qty = $('#txtMQty').val();
            objLTD.StartDate = $('#txtMStartDate').val();
            objLTD.Remark = $('#txtMRemark').val();
            objLTD.Dose = $("#txtRDose").val();
            objLTD.DoseUnit = $('#ddlRUnit').val();
            objLTD.IntervalId = $('#ddlMInterval').val().split('#')[0];
            objLTD.IntervalName = $("#ddlMInterval :selected").text();

            objLTD.DurationName = $("#ddlMDuration :selected").text();
            objLTD.DurationVal = $('#ddlMDuration').val();
            objLTD.Route = $('#ddlMroute').val();


            objLTD.IsDischargeMed = ($('#chkMIsDischarge').prop('checked') ? 1 : 0);
            objLTD.TypeOfMedicine = 0;
            objLTD.DoseTime = PatientReDoseTimeDis;

            //  dataLTD.push(objLTD);

            return objLTD;
        }



        var SaveReOrderEntry = function () {
            var resultLTD = GetReOrderDetails();

            $('#btnsReorderSave').attr('disabled', true).val("Submitting...");



            $.ajax({
                url: "Doctoer_Medicine_Order.aspx/SaveReorder",
                data: JSON.stringify({ item: resultLTD }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                async: false,
                dataType: "json",
                success: function (result) {

                    var responseData = JSON.parse(result.d);
                    var btnSave = $('#btnSave');

                    modelAlert(responseData.response, function () {

                        if (responseData.status)
                            window.location.reload();
                        else
                            $(btnsReorderSave).removeAttr('disabled').val('Save');

                    });



                }
            });

        }

        function Rddlintervalchange() {

            var id = $('#ddlMInterval').val().split('#')[0];
            BindReorderTimeLabel(id);
            calculateMQuantity();

        }


        function BindReorderTimeLabel(Id) {



            serverCall('Doctoer_Medicine_Order.aspx/GetIntervalTimes', { Id: Id }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#divReorderIntervalTimes').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<div class="col-md-6" style="color: blue;font-weight: bolder;">';
                        rdb += ' <input type="text" id="txtTime' + i + '" class="ItDoseTextinputText txtModelDoseTime required" value="' + item.TimeLable + '"  />';

                        rdb += '</div>';


                        $('#divReorderIntervalTimes').append(rdb);
                    });
                    $('.txtModelDoseTime').timepicker({
                        timeFormat: 'h:mm p',
                        interval: 10,
                        minTime: '00:01',
                        maxTime: '11:59pm',
                        // defaultTime: new Date(),
                        startTime: '00:01',
                        dynamic: false,
                        dropdown: true,
                        scrollbar: true
                    });

                } else {
                    $('#divReorderIntervalTimes').empty();
                }

            });



        }



        function DiscontinueOrder(Id) {
            modelConfirmation('Confirmation!!!', 'Are You Sure You Want To Discontinue The Order', 'Continue', 'Close', function (response) {
                if (response) {
                    serverCall('Doctoer_Medicine_Order.aspx/DiscontinueOrder', { Id: Id }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            modelAlert(responseData.response, function () {

                                window.location.reload();
                                 
                            });
                        }
                        else { modelAlert(responseData.response); }
                    });
                }
            });
        }
    </script>

</body>
</html>
