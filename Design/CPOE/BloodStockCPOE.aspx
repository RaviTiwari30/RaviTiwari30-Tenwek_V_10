<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BloodStockCPOE.aspx.cs" Inherits="Design_IPD_BloodStockCPOE" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Room Billing</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
      <link rel="stylesheet" href="../../Styles/jquery-ui.css" />
      <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
     <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckUnSaveData.js"></script>
   
      <script type="text/javascript">
          $(function () {
              $('#ucDate').change(function () {
                  ChkDate();
              });
              $('#toDate').change(function () {
                  ChkDate();
              });
          });

          function ChkDate() {
              $.ajax({
                  url: "../Common/CommonService.asmx/CompareDate",
                  data: '{DateFrom:"' + $('#ucDate').val() + '",DateTo:"' + $('#toDate').val() + '"}',
                  type: "POST",
                  async: true,
                  dataType: "json",
                  contentType: "application/json; charset=utf-8",
                  success: function (mydata) {
                      var data = mydata.d;
                      if (data == false) {
                          $('#lblMsg').text('To date can not be less than from date!');
                          $('#btnSearch').attr('disabled', 'disabled');
                         
                      }
                      else {
                          $('#lblMsg').text('');
                          $('#btnSearch').removeAttr('disabled');
                      }
                  }
              });
          }

    </script>
</head>
<body>
    <form id="form1" runat="server">
     <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
            </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">           
                <b>Blood Stock</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />          
        </div>                     
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                   Search Criteria
                </div>
               
              <div class="POuter_Box_Inventory">

                  <table style="width: 98%;border-collapse:collapse">
                      <tr>
                          <td style="width: 12%;text-align:right">Collection ID :&nbsp;</td>
                           <td style="width: 15%;text-align:left"> <asp:TextBox ID="txtCollectionID" runat="server" MaxLength="30" Width="150px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbCollection" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID="txtCollectionID"></cc1:FilteredTextBoxExtender></td>
                           <td style="width: 15%;text-align:right">Component Name :&nbsp;</td>
                           <td style="width: 20%;text-align:left"><asp:DropDownList ID="ddlComponentName" runat="server" Width="150px"></asp:DropDownList></td>
                           <td style="width: 10%;text-align:right">Tube No :&nbsp;</td>
                           <td style="width: 26%;text-align:left"><asp:TextBox ID="txtTubeNo" runat="server" MaxLength="20" Width="150px"></asp:TextBox></td>
                      </tr>

                        <tr>
                          <td style="width: 12%;text-align:right">Bag Type :&nbsp;</td>
                           <td style="width: 15%;text-align:left"><asp:DropDownList ID="ddlBagType" runat="server" Width="150px"></asp:DropDownList></td>
                           <td style="width: 15%;text-align:right">Date From :&nbsp;</td>
                           <td style="width: 20%;text-align:left">
                             
                                <asp:TextBox ID="ucDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                    Width="150px" onchange="ChkDate();" ></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                              
                           </td>
                           <td style="width: 12%;text-align:right">To Date :&nbsp;</td>
                           <td style="width: 26%;text-align:left">
                            
                               <asp:TextBox ID="toDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                                    Width="150px" onchange="ChkDate()"></asp:TextBox>
                                <cc1:CalendarExtender ID="caltoDate" runat="server" TargetControlID="toDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                               
                           </td>
                      </tr>

                        <tr>
                          <td colspan="6" style="width: 98%;text-align:center"><asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server"
                                OnClick="btnSearch_Click" />
                            <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server"
                                OnClick="btnPrint_Click" /></td>                           
                        </tr>                       

                  </table>
        
        </div>     
                
            </div>
           
        
        <div id="pnlHide" runat="server" visible="false" class="POuter_Box_Inventory">
            <asp:GridView ID="grdStock" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" Width="100%"
                OnPageIndexChanging="grdStock_PageIndexChanging">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                           <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Collection ID">
                        <ItemTemplate>
                            <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%#Eval("BloodCollection_ID")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>



                    <asp:TemplateField HeaderText="Component Name">
                        <ItemTemplate>
                            <asp:Label ID="lblComponentName" runat="server" Text='<%#Eval("ComponentName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bag Type">
                        <ItemTemplate>
                            <asp:Label ID="lblBagType" runat="server" Text='<%#Eval("BagType")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tube No.">
                        <ItemTemplate>
                            <asp:Label ID="lblBBTubeNo" runat="server" Text='<%#Eval("BBTubeNo")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Entry Date">
                        <ItemTemplate>
                            <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Expiry Date">
                        <ItemTemplate>
                            <asp:Label ID="lblExpiryDate" runat="server" Text='<%#Eval("ExpiryDate")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>    

    </div>
    </form>
</body>
</html>
