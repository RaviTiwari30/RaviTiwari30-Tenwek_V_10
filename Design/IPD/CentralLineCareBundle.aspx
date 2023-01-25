<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CentralLineCareBundle.aspx.cs" Inherits="Design_IPD_CentralLineCareBundle" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>
    <style type="text/css">
        .col-md-16 {
              display: flex;
            }
        .col-md-16 > div {
                  border: 1px solid black;
                }
            
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
   <%-- <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#spnPatientID").text('<%=Request.QueryString["PID"].ToString() %>');
            $("#spnTransactionID").text('<%=Request.QueryString["TID"].ToString() %>');
            //bindData();
        });
        function validate() {
            if ($('#txtHoursPostInsertion').val() == "" && $('#txtAppropriateHand').val() == "" && $('#txtAppearence').val() == "" && $('#txtAnyPatientInterference').val() == "" && $('#txtCatheterFlushedWith').val() == "" && $('#txtInjectionPortCleanedWith').val() == "" && $('#txtDailyReviewNecessity').val() == "" && $('#txtCatheterRemovalReason').val() == "" && $('#txtComments').val() == "") {
                modelAlert("Please Fill Details.", function () { });
                return false;
            }
        }

    </script>

    <form id="form2" runat="server">
        
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <b>Central Line Care Bundle </b>
                <br />
            
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
           <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
               <div class="Purchaseheader" style="text-align: left;">
                   Central Line Care Bundle
                </div>
 
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <div class="col-md-2" >Date
                        </div>
                     <div class="col-md-5">
                          <span  style="display:none;"  id="spnTransactionID"></span>
                   
                        <span style="display:none;" id="spnPatientID"></span>
                        
                        <span  style="display:none;"  id="spnEditPatientNote"></span>
                                   <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server"  Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                           
                        </div>
                     <div class="col-md-2" >Time
                        </div>
                     <div class="col-md-8">
                          <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                          
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            
                        </div>
                    </div>
                </div>
                 
 
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="row">
                    <div class="col-md-24">
                        <table style="width:100%;" class="FixedTables" >
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >1</td>
                              <td class="GridViewLabItemStyle" >Hours Post Insertion(In Hours)</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:TextBox ID="txtHoursPostInsertion" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="4" ></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtHoursPostInsertion" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
                              </td>
                        </tr>
                         <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >2</td>
                              <td class="GridViewLabItemStyle" >Name of Person Checking</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtPersonChecking" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50" disabled ></asp:TextBox>
                          
                              </td>
                        </tr> 
                            <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >3</td>
                              <td class="GridViewLabItemStyle" >Appropriate Hand Hygiene followed before handling patient:hand wash or hand rub? </td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:TextBox ID="txtAppropriateHand" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                         
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >4</td>
                              <td class="GridViewLabItemStyle" >Appearence of protective bandage layer, wet soiled or OK
</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtAppearence" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >5</td>
                              <td class="GridViewLabItemStyle" >Any Patient Interference</td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtAnyPatientInterference" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >6</td>
                              <td class="GridViewLabItemStyle" >Details of Catheter site  and limb e.g.Pain ,Limb swelling pressure sores Erithema Ok</td>
                              <td class="GridViewLabItemStyle" > <asp:TextBox ID="txtCatheterSiteDetails" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                        </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >7</td>
                              <td class="GridViewLabItemStyle" >Catheter Flushed with?
</td>
                              <td class="GridViewLabItemStyle" ><asp:TextBox ID="txtCatheterFlushedWith" CssClass="" runat="server" Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                           </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >8</td>
                              <td class="GridViewLabItemStyle" >Injection Port cleaned with? </td>
                              <td class="GridViewLabItemStyle" >
                                  <asp:TextBox ID="txtInjectionPortCleanedWith" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static" MaxLength="50"  ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >9</td>
                              <td class="GridViewLabItemStyle" >Daily review of necessity does patient still need catheter?</td>
                              <td class="GridViewLabItemStyle" >
                                   <asp:TextBox ID="txtDailyReviewNecessity" CssClass="" runat="server" Width="400px"  ClientIDMode="Static"  MaxLength="50" ></asp:TextBox>
                          
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >10</td>
                              <td class="GridViewLabItemStyle" >Catheter removed? Reason for Removal</td>
                              <td class="GridViewLabItemStyle" >
                                    <asp:TextBox ID="txtCatheterRemovalReason" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static"  MaxLength="50"  ></asp:TextBox>
                         
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                              </td>
                        </tr>
                             <tr>
                            <td class="GridViewLabItemStyle" style="width:20px;" >11</td>
                              <td class="GridViewLabItemStyle" >Any Other Comments</td>
                              <td class="GridViewLabItemStyle" >
                                    <asp:TextBox ID="txtComments" CssClass="" runat="server"  Width="400px"  ClientIDMode="Static"  MaxLength="50"  ></asp:TextBox>
                         
                              </td>
                        </tr>
                        </table>
                    </div>
                </div>
               
               
               
               
                
                </div>
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton"  OnClientClick="return validate();"   />
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return validate();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
               <%--  <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />
            
              <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="SaveData();" />--%>
            </div>
                 
             <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hours Post Insertion">
                            <ItemTemplate>
                                <asp:Label ID="lblHoursPostInsertion" runat="server" Text='<%#Eval("HoursPostInsertion") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Appropriate Hand ">
                            <ItemTemplate>
                                <asp:Label ID="lblAppropriateHand" runat="server" Text='<%#Eval("AppropriateHand") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Appearence of protective ">
                            <ItemTemplate>
                                <asp:Label ID="lblAppearence" runat="server" Text='<%#Eval("Appearence") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Any Patient Interference">
                            <ItemTemplate>
                                <asp:Label ID="lblAnyPatientInterference" runat="server" Text='<%#Eval("AnyPatientInterference") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Details of Catheter site ">
                            <ItemTemplate>
                                <asp:Label ID="lblCatheterSiteDetails" runat="server" Text='<%#Eval("CatheterSiteDetails") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Catheter Flushed with">
                            <ItemTemplate>
                                <asp:Label ID="lblCatheterFlushedWith" runat="server" Text='<%#Eval("CatheterFlushedWith") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Injection Port cleaned with"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblInsertionPortCleanedWith" runat="server" Text='<%#Eval("InsertionPortCleanedWith") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Daily review of necessity "  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblDailyReviewNecessity" runat="server" Text='<%#Eval("DailyReviewNecessity") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Catheter removed? Reason for Removal" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblCatheterRemovalReason" runat="server" Text='<%#Eval("CatheterRemovalReason") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Any Other Comments">
                            <ItemTemplate>
                                <asp:Label ID="lblComment" runat="server" Text='<%#Eval("Comment") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Checked By">
                            <ItemTemplate>
                                <asp:Label ID="lblCheckedBy" runat="server" Text='<%#Eval("CheckedBy1")  %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="PatientID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID1" runat="server" Text='<%# Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Transaction ID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" runat="server" Text='<%# Eval("TransactionID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblEntry" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" >
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>  
                                            
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60" />
                        </asp:TemplateField>
                    <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgbtnEdit1" AlternateText="Edit" CommandName="Print" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                                <asp:Label ID="lblID1" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                
                                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="60" />
                        </asp:TemplateField>
                    
                    </Columns>
                </asp:GridView>
            </div>
             
         
        </div>
    </form>

</body>
</html>

