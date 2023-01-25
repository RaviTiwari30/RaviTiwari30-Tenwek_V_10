<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientReturnIndent.aspx.cs"
    Inherits="Design_IPD_PatientReturnIndent" %>
    <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">  

    <title></title>
    
   <%-- <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
      <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <script type="text/javascript" src="../../Scripts/Search.js"></script>   
    <style type="text/css">
        .auto-style1 {
            width: 20%;
        }
    </style>


    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtReqQty').keyup(function (e) {
                if (/\D/g.test(this.value)) {
                    // Filter non-digits from input value.
                    this.value = this.value.replace(/\D/g, '');
                }
            });
        });
		
		
		   var createReturnIndent = function (btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
              __doPostBack('btnReturn', '');

        }
		
		
		
    </script>
</head>
<body>
    <form id="form1" runat="server">

     <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
      <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Medicine Return </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>

  

        <div class="POuter_Box_Inventory">

            
             <div class="content" style="padding-left: 25px;text-align: center;">
           
        <div  style=" overflow:auto; height:250px;text-align:left;padding:5px;">

                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 15%;text-align:right;" >
                        <asp:Label ID="lblDept" runat="server" Text="Department :&nbsp;"></asp:Label>
                    </td>
                    <td  style="text-align:left;" class="auto-style1" >
                        <asp:DropDownList ID="ddlDept" runat="server" Width="164px" ClientIDMode="Static" OnSelectedIndexChanged="ddlDept_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList>  <span style="color: red; font-size: 10px;">*</span>
                    </td>
                    <td style="width: 15%;text-align:right;">
                        Requisition Type :
                    </td>
                    <td class="auto-style1">
                        <asp:DropDownList ID="ddlRequestType" runat="server" Width="102px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 15%;text-align:right;">
                       
                    </td>
                    <td style="width:45%">
                       
                    </td>
                </tr></table>
            <br />
            <asp:GridView ID="grdRequsition" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" >
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ItemID" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' ></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Medicine Name" >
                        <ItemTemplate>
                            <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Sub Group" >
                        <ItemTemplate>
                            <asp:Label ID="lblDisplayName" runat="server" Text='<%#Eval("DisplayName") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                    </asp:TemplateField>

                      <asp:TemplateField HeaderText="IsExpirable" >
                        <ItemTemplate>
                            <asp:Label ID="lblIsExpirable" runat="server" Text='<%#Eval("IsExpirable") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>

                      <asp:TemplateField HeaderText="Unit Type" >
                        <ItemTemplate>
                            <asp:Label ID="lblUnitType" runat="server" Text='<%#Eval("UnitType") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>

                       <asp:TemplateField HeaderText="InHand Qty.">
                        <ItemTemplate>
                            <asp:Label ID="lblInHandUnits" runat="server" Text='<%#Eval("InHandUnits") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>     
                    
                     <asp:TemplateField HeaderText="Req.Qty.">
                        <ItemTemplate>
                           <asp:TextBox ID="txtReqQty" runat="server" Width="80px"  ClientIDMode="Static"></asp:TextBox>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>

                    <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="Server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="30px"/>
                        </asp:TemplateField>
               
                  
                </Columns>
            </asp:GridView>

            </div>

            <div class="content">
                <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Narration 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                             <asp:TextBox ID="txtNarration" CssClass="ItDoseTextinputText" runat="server"></asp:TextBox>
                     
                              
                        </div>
                    </div>

                 <div class="row">
                        <div class="col-md-22">
                           <asp:Button ID="btnReturn" runat="server" Text="Save"  OnClientClick="return createReturnIndent(this)"   CssClass="ItDoseButton" OnClick="btnReturn_Click"   />
                        </div>
                    </div>



                
               
            </div>
     
       
        </div>
            </div>

        </div>
    </form>
</body>
</html>
