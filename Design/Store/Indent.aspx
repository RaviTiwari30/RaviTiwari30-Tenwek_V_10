<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Indent.aspx.cs" Inherits=" Design_Store_Indent "  MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>HIS</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
     <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <script type="text/javascript" src="../../Scripts/Search.js"></script>  
     <script src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <style type="text/css">
        .style1 {
            width: 10%;
        }
    </style>
</head>
<body  runat="server">
    <form id="form1" runat="server">
        &nbsp;<ajax:ScriptManager ID="ScriptManager1" runat="server">
        </ajax:ScriptManager>
         <script type="text/javascript" >
             var keys = [];
             var values = [];
             $(document).ready(function () {
                 var options = $('#<% = ListBox1.ClientID %> option');
                 $.each(options, function (index, item) {
                     keys.push(item.value);
                     values.push(item.innerHTML);
                 });

                 $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                     searchByInBetween("", "", document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                     FindDose();
                     GetMedicineStock();
                 });
             });
             $(document).ready(function () {
                 check();
                 $('#<%=ListBox1.ClientID%>').change(function () {
                     GetMedicineStock();
                 });

             });
             function GetMedicineStock() {

                 if ($('#<%=ListBox1.ClientID%>').val() != null) {
                     var MedicineID = $('#<%=ListBox1.ClientID%>').val().split('#')[0];
                     var DeptLedgerNo = $('#ddlDept').val();
                     if (DeptLedgerNo != 0) {
                         $.ajax({
                             url: 'Indent.aspx/GetMedicineStock',
                             data: '{MedicineID:"' + MedicineID + '",DeptLedgerNo:"' + DeptLedgerNo + '"}',
                             type: 'Post',
                             contentType: 'application/json; charset=utf-8',
                             dataType: 'json',
                             success: function (result) {
                                 DeptLedStock = jQuery.parseJSON(result.d);
                                 if (result.d != '' && result.d != null) {
                                     var Output = $('#sc_Deptstock').parseTemplate(DeptLedStock);
                                     $('#divDeptStock').html(Output);
                                     $('#divDeptStock').show();
                                 }
                                 else {
                                     $('#divDeptStock').hide();
                                 }
                             },
                             error: function (xhr, status) {
                                 window.status = status + "\r\n" + xhr.responseText;
                             }

                         });
                     }

                 }
                 else {
                     $('#divDeptStock').html('');
                     $('#divDeptStock').hide();
                 }
             }
             function validatedot() {
                 if (($("#<% = txtTransferQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<% = txtTransferQty.ClientID%>").val('');
                return false;
            }
            return true;
        }
        function check() {
            if ($('#chkOtherItems').is(':checked')) {
                $('#txtOtherMedicine').attr('disabled', false);
                $('#ListBox1').attr('disabled', true);
            }
            else {
                $('#txtOtherMedicine').attr('disabled', true);
                $('#ListBox1').attr('disabled', false);
            }
        }
    </script>
   <script type="text/javascript">
       $(document).ready(function () {
           $TID ="<%=ViewState["TID"].ToString()%>" ;
           $.ajax({
               url: 'Indent.aspx/GetPatientAllery',
               data: '{TID:"' +$TID+ '"}',
               type: 'Post',
               contentType: 'application/json; charset=utf-8',
               dataType: 'json',
               success: function (result) {
                   if (result.d != '' && result.d != null) {
                       var Data=jQuery.parseJSON(result.d);
                       modelAlert('Allergies :' + Data[0].Allergies + '<br> Medications :' + Data[0].Medications);
                   }
                   else {
                      
                   }
               },
               error: function (xhr, status) {
                   window.status = status + "\r\n" + xhr.responseText;
               }

           });
       });
    </script>
    <script type="text/javascript">
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
            }
            return true;
        }
        function validate(btn) {

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('btnSave', '');

        }

        function validateQty() {
            if ($("#<%=ddlDept.ClientID%> option:selected").text() == "Select") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Department');
                $("#<%=ddlDept.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<% = txtTransferQty.ClientID%>").val()) <= 0) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Quantity');
                $("#<% = txtTransferQty.ClientID%>").focus();
                return false;
            }
            if ($("#<%=chkOtherItems.ClientID%>").is(':checked')) { } else {

                if ($("#<%=ListBox1.ClientID%>").val().split('#')[4] == "1") {

                    var Ok = confirm('This Item is Non Payable.Do You Want To Prescribe');
                    if (Ok) {
                        __doPostBack('btnSelect', '');
                    }
                    else {
                        return false;
                    }
                }
            }
        }

        function AddMedicine(sender, evt) {
            if (evt.keyCode > 0) {
                keyCode = evt.keyCode;
            }
            else if (typeof (evt.charCode) != "undefined") {
                keyCode = evt.charCode;
            }
            if (keyCode == 13) {
                document.getElementById('btnAddItem').click();
            }
        }
    </script>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Patient Requisition </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
            <div class="POuter_Box_Inventory">
                <div id="HIIDEN" class="content" runat="server">
                    <div style="padding-left: 25px">
                        <table>
                            <tr>
                                <td align="right" style="height: 67px">Name :
                                </td>
                                <td align="left" style="height: 67px">
                                    <asp:TextBox ID="txtName" runat="server" CssClass="ItDoseTextinputText" Width="150px"></asp:TextBox>
                                </td>
                                <td align="right" style="height: 67px">IPD No. :
                                </td>
                                <td align="left" style="height: 67px">
                                    <asp:TextBox ID="txtCRNo" runat="server" CssClass="ItDoseTextinputText" Width="100px"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="CrNo" runat="server" FilterMode="ValidChars" ValidChars="."
                                        FilterType="Custom, Numbers" TargetControlID="txtCRNo">
                                    </cc1:FilteredTextBoxExtender>
                                </td>
                                <td align="center" style="height: 67px">
                                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" Width="60px" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="content">
                        <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPatient_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IPD No.">
                                    <ItemTemplate>
                                        <%#Eval("TransactionID") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemTemplate>
                                        <%#Eval("PName") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Address">
                                    <ItemTemplate>
                                        <%#Eval("Address") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Select">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="ASelect"
                                            ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("TransactionID") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <br />
                    <div>
                        <div style="clear: both; float: left; padding-left: 25px;">
                            <label class="labelForTag">
                                UHID :</label>
                            <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseTextinputText" Width="150px"></asp:Label>
                            <br />
                            <br />
                            <label class="labelForTag">
                                Name :</label>
                            <asp:Label ID="lblPatientName" runat="server" CssClass="ItDoseTextinputText" Width="150px"></asp:Label>
                            <br />
                            <br />
                            <label class="labelForTag">
                                Room No. :</label>
                            <asp:Label ID="lblRoomNo" runat="server" CssClass="ItDoseTextinputText" Width="150px"></asp:Label>
                        </div>
                        <div style="float: left; padding-left: 25px;">
                            <label class="labelForTag">
                                IPD No. :</label>
                            <asp:Label ID="lblTransactionNo" runat="server" CssClass="ItDoseTextinputText"></asp:Label>
                            <br />
                            <br />
                            <label class="labelForTag">
                                Panel :</label>
                            <asp:Label ID="lblPanelComp" runat="server" CssClass="ItDoseTextinputText"></asp:Label>
                            <br />
                            <br />
                            <label class="labelForTag">
                                Doctor:</label>
                            <asp:Label ID="lblDoctorName" runat="server" CssClass="ItDoseTextinputText"></asp:Label>
                        </div>
                    </div>
                    <br />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Issue Items
                </div>
              <div class="row">
                <div class="col-md-24">
                     <div class="row">
                         <div class="col-md-4"></div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rdoType_SelectedIndexChanged"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="0">Item Wise</asp:ListItem>
                                <asp:ListItem Value="1">Generic Wise</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                            <div class="col-md-4">
                            <label class="pull-left">
                                Requisition Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlRequestType" runat="server"  ClientIDMode="Static">
                                        </asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <asp:Button ID="btnSetItem" runat="server" CssClass="ItDoseButton" Text="Set Medicine" ClientIDMode="Static" />
                            </div>
                         <div class="col-md-2">
                             <asp:Button ID="btnWord" runat="server" CssClass="ItDoseButton" OnClick="btnWord_Click"
                                            Text="Search"  Visible="false" />
                         </div>
                    </div>
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Sub Group 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlSubcategory" runat="server" TabIndex="2"  AutoPostBack="True"
                                            OnSelectedIndexChanged="ddlSubcategory_SelectedIndexChanged">
                                        </asp:DropDownList>
                        </div>
                            <div class="col-md-4">
                            <label class="pull-left">
                                  <asp:Label ID="lblDept" runat="server" Text="Department"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept"  CssClass="requiredField" runat="server"  onchange="CheckDept();" ClientIDMode="Static">
                                        </asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtWord" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                                            onkeydown="MoveUpAndDownText(txtSearch,ListBox1,event);" onkeyup="suggestName(txtSearch,ListBox1,event);"
                                            Width="134px" Visible="false"></asp:TextBox>
                        </div>
                            
                    </div>
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInBetweenSearch" AutoCompleteType="Disabled" runat="server" TabIndex="3" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                             <label class="pull-left">
                                 Item List
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-12">
                             <asp:ListBox ID="ListBox1" runat="server" style="margin-top:2px;" CssClass="ItDoseDropdownbox" onchange="FindDose()"
                                     Width="380px" Height="150px" ClientIDMode="Static" ></asp:ListBox>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                  <asp:CheckBox ID="chkOtherItems" runat="server" Text="Other Medicine"  TextAlign="Left" ClientIDMode="Static" onclick="check()"   />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtOtherMedicine" runat="server" ClientIDMode="Static"></asp:TextBox>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" CssClass="serarchableddl" runat="server"></asp:DropDownList>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                              <asp:TextBox ID="txtTransferQty"  ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum requiredField" AutoCompleteType="Disabled"
                                            onkeyup="validatedot();" Width="50px" MaxLength="4" onkeypress="AddMedicine(this,event)"  TabIndex="4" ></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterType="Custom, Numbers"
                                            ValidChars="." FilterMode="validChars" TargetControlID="txtTransferQty">
                                        </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                     <div class="row"></div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Narration
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemarks" runat="server"  
                                            ToolTip="Enter Remarks" />
                        </div>
                        <div class="col-md-3"></div>
                          <div class="col-md-3">
                            <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton"
                                            OnClick="btnAddItem_Click" ValidationGroup="r" OnClientClick="return validateQty()" />
                        </div>
                    </div>
                </div>
            </div>
                <table  style="width: 100%;border-collapse:collapse">
                                <tr>
                                     <td>
                            <table style="width:100%">
                                <tr>
                                    <td>
                                        <div id="divDeptStock">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                                </tr>
                                <tr>
                                    <td style="width:14%;text-align:right; display:none">Dose :&nbsp;</td>
                                    <td style="text-align: left; "  colspan="4">
                                        <table style="width:100%;border-collapse:collapse">
                                            <tr>
                                                <td style="text-align:left;display:none" class="auto-style5">
                                     <asp:TextBox ID="txtDose" runat="server" Width="80px"></asp:TextBox>
                                                </td>                                                                       
                                                <td style="text-align:right;display:none" class="auto-style6">
                                                    Times :</td>
                                                <td  style="text-align:left;width:6%;display:none">
                                                <asp:DropDownList ID="ddlTime" runat="server" Width="100px" ToolTip="Select Time" ClientIDMode="Static" onchange="QuantityCal();">
                                        </asp:DropDownList>
                                                </td>
                                                 <td style="text-align:right;display:none" class="auto-style7">Duration :&nbsp;&nbsp;</td>
                                                 <td style="text-align: left;width:6%;display:none">
                                        <span style="color: red; font-size: 10px;display:none">*</span><asp:DropDownList ID="ddlDuration" runat="server" Width="100px" ClientIDMode="Static" onchange="QuantityCal();"></asp:DropDownList>
                                                </td>
                                                   <td style="text-align:right;width:10%;display:none">Route :&nbsp;&nbsp;</td>
                                    <td style="text-align: left;width:6%;display:none">                                                                
                                         <%-- <asp:TextBox ID="txtDuration" runat="server" ToolTip="Select Duration" ClientIDMode="Static" 
                                                Width="90px" ></asp:TextBox>--%>
                                            
                                         <span style="color: red; font-size: 10px;display:none">*</span>
                                        <asp:DropDownList ID="ddlRoute" ClientIDMode="Static" runat="server" Width="100px"></asp:DropDownList></td>
                                            </tr>
                                        </table>  
                                        
                                        </td>                            
                                </tr>
                                <tr>
                                   
                                </tr>
                           
                </table>
            </div>
            <asp:Panel ID="pnlHide" Visible="false" runat="server">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <div class="Purchaseheader">
                        Item Details
                    </div>
                    <div class="content">
                        <asp:GridView ID="gvIssueItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="gvIssueItem_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name">
                                    <ItemTemplate>
                                        <%#Eval("ItemName")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="400px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Quantity">
                                    <ItemTemplate>
                                        <%#Eval("Qty")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Unit">
                                    <ItemTemplate>
                                        <%#Eval("UnitType")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="MS_Stk" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("MedStoreQty")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Dpt_Stk" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("DeptQty")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Avg_C" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAvCon" runat="server" Text='<%#Eval("AvgCon") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="L_InNo" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("IndentNo")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="L_RsdDt" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("RaisedDate")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="L_ReqQt" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("ReqQty")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="L_PenQt" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("PendingQty")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="L_Rsdby" Visible="false">
                                    <ItemTemplate>
                                        <%#Eval("Raisedby")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Dept. Qty.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDeptQty" ForeColor="Blue" Font-Bold="true" runat="server" Text='<%#Eval("DeptQty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Selected Dept. Qty">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSelectedDeptQty" ForeColor="Blue" Font-Bold="true" runat="server" Text='<%#Eval("MedStoreQty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Dose">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDose" runat="server" Text='<%#Eval("Dose") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Time">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Times") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="150" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Route">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRoute" runat="server" Text='<%#Eval("Route") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Duration in Days">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDurationDays" runat="server" Text='<%#Eval("DurationDays") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Duration in Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDuration" runat="server" Text='<%#Eval("Duration") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Doctor Name" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDoctorName" runat="server" Text='<%#Eval("DoctorName") %>'></asp:Label>
                                        <asp:Label ID="lblDoctorID" runat="server" Text='<%#Eval("DoctorID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Narration">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNarration" runat="server" Width="150px" Text='<%#Eval("Narration") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remove">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                            CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Remove Item" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        &nbsp;
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnlHide1" Visible="false" runat="server">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <table>
                        <tr>
                            <td style="width: 184px; text-align: center;">
                                <asp:Label ID="lblPanelID" runat="server" Style="display:none"></asp:Label>
                                <asp:Label ID="lblIPDCaseType_ID" runat="server" Style="display:none" ></asp:Label>
                                <asp:Label ID="lblRoomID" runat="server" Style="display:none"></asp:Label>
                                <asp:Label ID="lblDoctorID" runat="server" Style="display:none"></asp:Label>
                            </td>
                            <td style="width: 323px;"></td>
                            <td style="width: 166px; text-align: center;">&nbsp;<asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                                OnClick="btnSave_Click" OnClientClick="return validate(this);" ValidationGroup="a" Height="22px" />
                            </td>
                            <td style="width: 303px;text-align:left;">
                                <asp:CheckBox ID="chkprint" runat="server" Text="Print" />
                            </td>
                        </tr>
                    </table>

                </div>
            </asp:Panel>
        </div>
           <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" ClientIDMode="Static"
        popupdraghandlecontrolid="PopupHeader" Drag="true"   CancelControlID="btncancel1" PopupControlID="pnPreviousVisit"
        TargetControlID="btnSetItem" BehaviorID="mpe2">
    </cc1:ModalPopupExtender>
             <asp:Panel ID="pnPreviousVisit" runat="server" CssClass="pnlItemsFilter" style=" display:none;
        width: 100%; height: 350px;">
        <div>
        <div class="Purchaseheader" style="text-align: left;">
        Medicine Set And Indent Medicine&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <em ><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer" alt=""  onclick="closePatientDetail()" onkeypress="onKeyDown();"/>                               
                                to close</span></em>
                </div>
            <div><table><tr><td>Type :&nbsp;</td><td><input type="radio" id="rdoset" value="Set" name="Select" checked="checked" onclick="chkMedicineType()"/>Prescribe Set
                <input type="radio" id="rdoIndent" value="indent" name="Select"  onclick="chkMedicineType()"/>Indent Medicine &nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>Select Set :&nbsp;</td><td> <select id="ddlMedicineset" style="width:225px" onchange="LoadMedSetItems()"></select> </td></tr></table></div>
                                <table  style="width: 100%; border-collapse:collapse">
                <tr style="text-align:center">
                    <td colspan="4">
                        <div id="PatientMedicineSearchOutput" style="height:250px; overflow-y:scroll;" >
                        </div>
                    </td>
                </tr>
            </table>
    <div>
          <table style="text-align:center">
              <caption>
                  <asp:Button ID="btncancel1" runat="server" CssClass="ItDoseButton" style="display:none" Text="Cancel" />
              </caption>
          </table>
      </div>
          </div>
                 <span id="tempspnTimes" style="display:none"></span>
                 <span id="tempspnduration" style="display:none"></span>
                          <div style="text-align:center"> <input id="btnSaveSet" value="Save"  type="button" class="ItDoseButton" style="display:none" onclick="SaveSetItem();"/></div>
    </asp:Panel>
    </form>
       <script id="sc_Deptstock" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblDeptStock" style="border-collapse:collapse;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Dept. Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">Quantity</th>
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
                        <td id="tdDeptQuantity" class="GridViewLabItemStyle"><#=objRow.Quantity#></td>
                </tr>
            <#}#>
     </table>    
    </script>
    <script type="text/javascript">
        function FindDose() {
            if ($('#<%=ListBox1.ClientID%>').val() != null) {
                $('#<%=txtDose.ClientID %>').val($('#<%=ListBox1.ClientID%>').val().split('#')[5]);
                var dropdownlistbox = document.getElementById("ddlRoute")
                var givenValue = $('#<%=ListBox1.ClientID%>').val().split('#')[7];
                FindSelectedIndex(dropdownlistbox, givenValue);
                // CheckMedicineStock();
            }
        }
        function FindSelectedIndex(dropdownlistbox, givenValue) {
            for (var x = 0; x < dropdownlistbox.length - 1 ; x++) {
                if (givenValue == dropdownlistbox.options[x].text)
                    dropdownlistbox.selectedIndex = x;
            }
        }
        function setOptionByValue(select, value) {
            var options = select.options;
            for (var i = 0, len = options.length; i < len; i++) {
                if (options[i].value === value) {
                    alert(options[i].value);
                    select.selectedIndex = i;
                    return true; //Return so it breaks the loop and also lets you know if the function found an option by that value
                }
            }
            return false; //Just to let you know it didn't find any option with that value.
        }
        function QuantityCal() {
            var Time = $('#<%=ddlTime.ClientID%>').val();
            var Duration = $('#<%=ddlDuration.ClientID%>').val();

            var MedicineType = $("#<%=ListBox1.ClientID %>").val().split('#')[6];
            var Quantity = 0;
            if (MedicineType == "tablet" || MedicineType == "capsule") {
                Quantity = Time * Duration;
                if (Quantity != 0)
                    $('#<%=txtTransferQty.ClientID%>').val(Quantity);
        else
            $('#<%=txtTransferQty.ClientID%>').val('1');
    }
    else if (MedicineType == "Syrup" || MedicineType == "EyeDrop" || MedicineType == "EarDrop" || MedicineType == "NosalDrop" || MedicineType == "Tube"
        || MedicineType == "Lotion" || MedicineType == "Cream" || MedicineType == "Injection" || MedicineType == "Inhaler"
        ) {
        $('#<%=txtTransferQty.ClientID%>').val('1');
        }
        else {
            $('#<%=txtTransferQty.ClientID%>').val('');
        }
}
function closePatientDetail() {
    $find("mpe2").hide();
}
function pageLoad(sender, args) {
    if (!args.get_isPartialLoad()) {
        $addHandler(document, "keydown", onKeyDown);
    }
}
function onKeyDown(e) {
    if (e && e.keyCode == Sys.UI.Key.esc) {
        if ($find('mpe2')) {
            $find('mpe2').hide();
        }
    }
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
                            bindtime(ddlSetTime);
                            bindDuration(ddlSetDuration);
                            if ($(this).find('#spnTimes').html() != "") {
                                $(this).find('#ddlSetTime' + Sno).val($(this).find('#spnTimes').html());
                            }
                            if ($(this).find('#spnduration').html() != "") {
                                $(this).find('#ddlSetDuration' + Sno).val($(this).find('#spnduration').html());
                            }
                        }
                    });
                    BindDropdown();
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
            url: "Indent.aspx/LoadIndentItems",
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
                            bindtime(ddlSetTime)
                            bindDuration(ddlSetDuration)
                        }
                    });

                    BindDropdown();
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
function SaveSetItem() {

    if ($("#ddlMedicineset").val() != "0") {
        var data = new Array();
        var Obj = new Object();
        jQuery("#Table1 tr").each(function (i) {

            var id = jQuery(this).attr("id");
            var $rowid = jQuery(this).closest("tr");
            if (id != "Tr1") {
                if ($(this).find("#chkSelect").is(":checked")) {
                    var Sno = jQuery.trim($rowid.find("#tdSno").text());
                    Obj.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                    Obj.MedicineName = jQuery.trim($rowid.find("#tdItemName").text());
                    Obj.Quantity = jQuery.trim($rowid.find("#txtQtySet").val());
                    Obj.Dose = jQuery.trim($rowid.find("#txtsetDose").val());
                    Obj.Time = jQuery.trim($rowid.find('#ddlSetTime' + Sno).val());
                    Obj.Duration = jQuery.trim($rowid.find('#ddlSetDuration' + Sno).val());
                    Obj.Route = jQuery.trim($rowid.find("#ddlRoute1").val());
                    Obj.TID = '<%=Request.QueryString["TransactionID"] %>';
                        Obj.PID = '<%=Request.QueryString["Patientid"]%>';
                        Obj.LnxNo = '<%=Request.QueryString["LnxNo"]%>';
                        Obj.UnitType = jQuery.trim($rowid.find("#tdunittype").text());
                        Obj.Dept = $("#ddlDept").val();

                        Obj.IndentType = $("#ddlRequestType").val();
                        Obj.DoctorID = $("#lblDoctorID").text();
                        Obj.IPDCaseType_ID = $("#lblIPDCaseType_ID").text();
                        Obj.Room_ID = $("#lblRoomID").text();
                        data.push(Obj);
                        Obj = new Object();
                    }
                }
            });

            if (data.length > 0) {
                $.ajax({
                    url: "Indent.aspx/InsertIndent",
                    data: JSON.stringify({ Data: data }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: true,
                    dataType: "json",
                    success: function (result) {
                        Data = result.d;
                        if (Data == "1") {
                            $(this).find("#chkSelect").attr('checked', false);
                            alert('Record Saved Successfully');
                            window.location.reload(true);
                            $find("mpe2").hide();
                        }
                        $("#btnSave").attr('disabled', false);
                    },
                    error: function (xhr, status) {
                        alert(status + "\r\n" + xhr.responseText);
                        $("#btnSave").attr('disabled', false);
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
    }
    function IndentMedicine() {
        $('#ddlMedicineset option').remove();
        var TID = '<%=Request.QueryString["TransactionID"]%>';
            $.ajax({
                url: "Indent.aspx/LoadIndentMedicine",
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

        function BindDropdown() {
            $('#Table1 tr').each(function () {
                if ($(this).attr("id") != "Tr1") {
                    if ($(this).find('#spnTimes').html() != "") {
                        var Sno = $(this).find("#tdSno").text();
                        //  var Time = $(this).find('#ddlSetTime' + Sno).val();
                        //   alert(Time);
                        //  $(this).find('#ddlSetTime' + Sno).text($(this).find('#spnTimes').html());
                    }
                    if ($(this).find('#spnroute').html() != "") {
                        $(this).find('#ddlRoute1').val($(this).find('#spnroute').html());
                    }

                }
            });
        }

    </script>
      <script id="tb_PatientMedicineSearch" type="text/html">
  <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1"
        style="width:100%; border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width:5%;"></th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%;">Select</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5%">itemID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:25%;">Medicine name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Quantity</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Dose</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Duration</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:20%;">Route</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:20%; display:none">UnitType</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:20%; display:none">Medicine Type</th>
                
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
                          <td class="GridViewLabItemStyle" id="tdSno" style="width:10px;"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" style="width:5%"><input type="checkbox" id="chkSelect" checked="checked" /></td>
                        <td id="tdItemID" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.ItemID#></td>
                        <td  id="tdItemName" class="GridViewLabItemStyle" style="width:25%"><#=objRow.NAME#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;width:10%"><input  type="text" class="ItDoseTextinputText" id="txtQtySet"  value="<#=objRow.quantity#>" style="width:70px" /></td>
                        <td id="tdDose" class="GridViewLabItemStyle" style="width:10%"><input  type="text" class="ItDoseTextinputText" id="txtsetDose" style="width:70px" value="<#=objRow.Dose#>" /></td>
                        <td id="tdTime" class="GridViewLabItemStyle" style="width:10%"><span id="spnTimes" style="display:none"><#=objRow.times#></span> <select id="ddlSetTime<#=j+1#>" style="width:120px" onchange="calculateLPopupQty();"> </select></td>
                        <td id="tdduration" class="GridViewLabItemStyle"style="width:14%"><span id="spnduration" style="display:none"><#=objRow.Duration#></span>  <select id="ddlSetDuration<#=j+1#>"  clientidmode="Static" style="width:120px" onchange="calculateLPopupQty();"> </select>  </td>
                        <td id="tdroute1" class="GridViewLabItemStyle"style="width:16%"> 
                            <span id="spnroute" style="display:none"><#=objRow.Route#></span><select id="ddlRoute1" runat="server"></select></td>
                        <td id="tdunittype" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.unittype#></td>   
                         <td id="tdMedicineType" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.MedicineType#></td>   
                </tr>
           <#}#>
     </table>    
    </script>
    <script type="text/javascript">
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
        function calculateLPopupQty() {
            $('#Table1 tr').each(function () {
                if ($(this).attr("id") != "Header") {
                    var Sno = $(this).find("#tdSno").text();
                    $('#tempspnTimes').html($(this).find('#ddlSetTime' + Sno).val());
                    var Time = $('#tempspnTimes').html().split('#')[0];
                    $('#tempspnduration').html($(this).find('#ddlSetDuration' + Sno).val());
                    var Duration = $('#tempspnduration').html().split('#')[0];
                    var MedicineType = $(this).closest("tr").find('#tdMedicineType').text();
                    var Quantity;
                    if (MedicineType == "Tablet" || MedicineType == "Capsule") {
                        Quantity = Time * Duration;
                        if (Quantity != 0)
                            $(this).find('#txtQtySet').val(Quantity);
                        else
                            $(this).find('#txtQtySet').val('1');
                    }
                    else if (MedicineType == "Syrup" || MedicineType == "EyeDrop" || MedicineType == "EarDrop" || MedicineType == "NosalDrop" || MedicineType == "Tube"
                                || MedicineType == "Lotion" || MedicineType == "Cream" || MedicineType == "Injection" || MedicineType == "Inhaler"
                                ) {
                        $('#<%=txtTransferQty.ClientID%>').val('1');
                    }
                    else
                        $(this).find('#txtQtySet').val('');
            }
            });
    }
    function CheckDept() {
        if ($('#ddlDept').val() == "0") {
            $('#btnSetItem').attr('disabled', 'disabled');
            document.getElementById("btnSetItem").title = "Set Button Enable After Selecting The Department";
        }
        else {
            $('#btnSetItem').attr('disabled', false);
            document.getElementById("btnSetItem").title = "Click To Prescribe Set Medicine";
        }
    }
    $('#<%=btnSetItem.ClientID%>').click(function () {
        if ($("#<%=ddlDept.ClientID%> option:selected").text() == "Select") {
            $("#<%=lblMsg.ClientID%>").text('Please Select Department');
            $("#<%=ddlDept.ClientID%>").focus();
            $find("mpe2").hide();
            $('#ddlMedicineset').attr('disabled', true);
            $("#rdoset").attr('disabled', true);
            return false;
        }
        else {
            LoadMedicineSet();
            $('#ddlMedicineset').attr('disabled', false);
            $("#rdoset").attr('disabled', false);
            $("#<%=lblMsg.ClientID%>").text('');
        }
    });
    </script>
</body>
</html>
