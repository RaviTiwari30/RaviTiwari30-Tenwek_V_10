<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BioHazards.aspx.cs" Inherits="Design_OPD_BioHazards" %>
  <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });


        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
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
        function validate()
        {
            if ($('#txtVehicleNo').val() == "") {
                $('#lblMsg').text("Please Enter The Vehicle No.");
                $('#txtVehicleNo').focus();
                return false;
            }
            if ($('#txtTimeIn').val() == "") {
                $('#lblMsg').text("Please Enter The In Time");
                $('#txtTimeIn').focus();
                return false;
            }
            if ($('#txtTimeOut').val() == "") {
                $('#lblMsg').text("Please Enter The Out Time");
                $('#txtTimeOut').focus();
                return false;
            }
            if ($('#txtCollectedBy').val() == "") {
                $('#lblMsg').text("Please Enter The Collected By");
                $('#txtCollectedBy').focus();
                return false;
            }
        }
        function NomericAndDot(element, evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if (
                //  (charCode != 45 || $(element).val().indexOf('-') != -1) &&      // “-” CHECK MINUS, AND ONLY ONE.
                (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
                (charCode < 48 || charCode > 57) &&
                (charCode != 8)) {
                $("#lblMsg").text('Enter Numeric Value Only Or One Dot Apply');
                return false;
            }
            else {
                var DigitsAfterDecimal = 1;
                var val = $(element).val();
                var valIndex = val.indexOf(".");
                if (valIndex > "0") {
                    if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Please Enter Valid Discount Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(element).val($(element).val().substring(0, ($(element).val().length - 1)))
                        return false;
                    }
                    else {
                        $("#lblMsg").text(' ');
                        return true;
                    }
                }
            }
        }
    </script>
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>BioHazards Record Sheet</b>
                <br />
                  <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table  style="width:100%;  " >
               <tr>
                   <td style="text-align:right">Date :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtDate" runat="server" Width="100px" ClientIDMode="Static"></asp:TextBox>
                       <span id="spnman" class="ItDoseLblError" style="font-size:8px" >*</span>
                   </td>
                   <td style="text-align:right">Vehicle No. :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtVehicleNo" runat="server" ClientIDMode="Static"></asp:TextBox>
                       <span id="Span1" class="ItDoseLblError" style="font-size:8px" >*</span>
                   </td>
                   <td style="text-align:right">Time IN :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtTimeIn" runat="server"  Width="100px" ClientIDMode="Static"></asp:TextBox><span id="Span2" class="ItDoseLblError" style="font-size:8px" >*</span></td>
                   <td style="text-align:right">Time Out :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtTimeOut" runat="server"  Width="100px" ClientIDMode="Static"></asp:TextBox><span id="Span3" class="ItDoseLblError" style="font-size:8px" >*</span></td>
               </tr>
                <tr>
                   <td style="text-align:right">Cat Yellow :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtCatYellow" runat="server"  Width="50px" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>(kg)</td>
                   <td style="text-align:right">Cat Yellow(Bags) :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtCatYellowBags" runat="server"  Width="50px" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox></td>
                   <td style="text-align:right">Cat Red :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtCatRed" runat="server"  Width="50px" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>(kg)</td>
                   <td style="text-align:right">Cat Red(Bags) :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtCatRedBags" runat="server"  Width="50px" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox></td>
               </tr>
                <tr>
                   <td style="text-align:right">Cat Blue :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtBlueCat" runat="server" Width="50px" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox>(kg)</td>
                   <td style="text-align:right">Cat Blue(Bags) :&nbsp;</td>
                   <td style="text-align:left"><asp:TextBox ID="txtBlueCatBags" runat="server" Width="50px" ClientIDMode="Static" onkeypress="return NomericAndDot(this,event)"></asp:TextBox></td>
                   <td style="text-align:right">Collected By</td>
                   <td style="text-align:left" colspan="2"><asp:TextBox ID="txtCollectedBy" ClientIDMode="Static" runat="server" Width="200px"></asp:TextBox><span id="Span4" class="ItDoseLblError" style="font-size:8px" >*</span></td>
                   <td style="text-align:right">&nbsp;</td>
                   <td> <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label></td>
               </tr>
            </table>
           
               
            </div>
          <div class="POuter_Box_Inventory" style="text-align: center;">
              <table style="width:100%">
                  <tr>
                  <td style="width: 488px; text-align:right"><em ><span style="color: #0000ff; font-size: 7.5pt">
                       (Type A or P to switch AM/PM)</span></em></td>
             <td style="text-align:left;">
                 
              <asp:Button ID="btnSave" OnClientClick="return validate()" runat="server" Text="Save" OnClick="btnSave_Click"  CssClass="ItDoseButton"/>
                         <asp:Button ID="btnUpdate" Visible="false" OnClientClick="return validate()" runat="server" Text="Update" OnClick="btnUpdate_Click"   CssClass="ItDoseButton"/>
                 <asp:Button  ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" Visible="false" OnClick="btnCancel_Click"/>
                   </td>
                      </tr>
                   </table>
              <div class="Purchaseheader">
                  Search
              </div>
              <table><tr>
                  <td style="text-align:right; width: 235px;">
                From Date :&nbsp</td>
                      <td style="text-align:right;">
                 <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" 
                            TabIndex="1"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender></td>
                      <td style="text-align:right; width: 277px;">
                To Date :&nbsp</td>
                      <td style="text-align:right;">
                <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"
                            Width="149px" TabIndex="2"></asp:TextBox>
                        <cc1:CalendarExtender ID="Todatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender></td></tr>
                  <tr>
                  <td style="text-align:left; width: 235px;">
                      &nbsp;</td>
                      <td style="text-align:right;">
                          &nbsp;</td>
                      <td style="text-align:center; width: 277px;">
                          <asp:Button ID="btnSearch" runat="server" ClientIDMode="Static" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" /></td>
                      <td style="text-align:right;">
                          &nbsp;</td></tr>
              </table>

                  </div>
         <div style="text-align:center"><table>
              <tr align="center">
                <td style="width: 15%"></td>
                        <td align="center" colspan="8">
                            <asp:Label ID="lblsummary" runat="server" Font-Bold="True" Font-Size="10pt" Width="750px"></asp:Label><asp:Panel
                                ID="Panel2" runat="server"  Width="750px" ScrollBars="Auto">
                                <asp:GridView ID="grdsummary" CssClass="GridViewStyle" Width="750px" runat="server"
                                    AllowPaging="True">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:GridView>
                            </asp:Panel>
                        </td>
                    </tr></table>
         </div>
          <div style="overflow: auto; padding: 3px; width: 952px;height: 274px;">
         <asp:GridView ID="grdBioHazards" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdBioHazards_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                           <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/Edit.png" CommandName="AEdit"
                                    CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                              <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>'></asp:Label>  
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Vehicle No.">
                            <ItemTemplate>
                              <asp:Label ID="lblVehicleNo" runat="server" Text='<%# Eval("VehicleNo") %>'></asp:Label>  
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time IN">
                            <ItemTemplate>
                                <asp:Label ID="lblTimeIN" runat="server" Text='<%# Eval("TimeIN") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Time Out">
                            <ItemTemplate>
                                <asp:Label ID="lblTimeOut" runat="server" Text='<%# Eval("TimeOut") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CAT Yellow">
                            <ItemTemplate>
                                <asp:Label ID="lblCatYellow" runat="server" Text='<%# Eval("YellowCat") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="CAT Yellow(Bags)">
                            <ItemTemplate>
                                <asp:Label ID="lblCatYellowBags" runat="server" Text='<%# Eval("YellowCatbags") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="CAT Red">
                            <ItemTemplate>
                                <asp:Label ID="lblCatRed" runat="server" Text='<%# Eval("RedCat") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="Cat Red(Bags)">
                            <ItemTemplate>
                                <asp:Label ID="lblCatRedBags" runat="server" Text='<%# Eval("RedCatBags") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="Cat Blue">
                            <ItemTemplate>
                                <asp:Label ID="lblCatBlue" runat="server" Text='<%# Eval("BlueCat") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="Cat Blue(Bags)">
                            <ItemTemplate>
                                <asp:Label ID="lblCatBlueBags" runat="server" Text='<%# Eval("BlueCatBags") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="Collected By">
                            <ItemTemplate>
                                <asp:Label ID="lblCollectedby" runat="server" Text='<%# Eval("TakenBy") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                         <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%# Eval("EntryBy") %>'></asp:Label>
                                <asp:Label ID="lblUserID" runat="server" Visible="false" Text='<%# Eval("UserID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                        <asp:TemplateField HeaderText="Entry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryDate" runat="server" Text='<%# Eval("EntryDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                        </asp:TemplateField> 
                     
                    </Columns>
                </asp:GridView>
         </div>
         
         <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTimeIn"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTimeIn"
    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time ON"
    InvalidValueMessage="Invalid Time ON"   Display="None"  ></cc1:MaskedEditValidator>
         <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
    TargetControlID="txtTimeOut"  AcceptAMPM="True">
</cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtTimeOut"
    ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Please Enter Time OFF"
    InvalidValueMessage="Invalid Time OFF" Display="None"  ></cc1:MaskedEditValidator>
   </div> 
</asp:Content>

