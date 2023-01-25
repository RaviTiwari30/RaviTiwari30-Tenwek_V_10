<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="CardPrint.aspx.cs" Inherits="Design_CardPrint" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
   <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });

        });

       

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $("#<%=grdCard.ClientID %>").hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
     <script type="text/javascript" >
         var getReport = function (patientid, callback) {
             serverCall('CardPrint.aspx/GetReport', { patientid: patientid }, function (response) {
                 var responseData = JSON.parse(response);
                 if (responseData.status)
                     window.open(responseData.responseURL);
                 else
                     moddelAlert(responseData.response);
             });
         }
         function labconcent(objRef) {
             var row = objRef.parentNode.parentNode;
             var Patient_ID = $(row).find('#lblPatientID').text();
             if (Patient_ID != '' && Patient_ID != 'null') {
                 getReport(Patient_ID, function () { });
             }
         }
         function WriteToFiles(ddata) {
             try {
                 window.location = 'barcode://?cmd=' + ddata + '&test=1&source=Barcode_Source_Registration';
             }
             catch (e) { alert('Error'); }
         }
         function PrintSticker(objRef) {
             if ('<%=Resources.Resource.StickerPrinting_OPD_Lab_Phar_Doc_Diet.Split('#')[0]%>' == "1") {
                 var ok = confirm("Do you Want to Print the Sticker");
                 if (ok == true) {
                     var row = objRef.parentNode.parentNode;
                     var PatientID = $(row).find('#lblPatientID').text();
                     $.ajax({
                         url: "Services/PatientRegistration.asmx/PrintSticker",
                         data: '{ PatientID:"' + PatientID + '"}', // parameter map       
                         type: "POST", // data has to be Posted    	        
                         contentType: "application/json; charset=utf-8",
                         timeout: 120000,
                         dataType: "json",
                         success: function (result) {
                             window.location = 'barcode://?cmd=' + result.d + '&test=1&source=Barcode_Source_Registration';
                         },
                         error: function (xhr, status) {
                             DisplayMsg('MM05', 'lblMsg');
                         }
                     });
                 }
                 else
                     return false;
             }
             else
             $('#lblMsg').text("Please On the Barcode Setting");
         }
         function pageLoad(sender, args) {
             if (!args.get_isPartialLoad()) {
                 $addHandler(document, "keydown", onKeyDown);
             }
         }
         function onKeyDown(e) {
             if (e && e.keyCode == Sys.UI.Key.esc) {
                 if ($find("mpe")) {
                     $find("mpe").hide();

                 }
             }
         }
         function closePatientDetail() {
             $find("mpe").hide();
         }

       
         </script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sc" runat="server">
        </ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Card Print</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-3">
                      <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b></div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtMrno" AutoCompleteType="Disabled" runat="server" data-title="Enter UHID (Press Enter To Search Patient)" ClientIDMode="Static" onkeyup="if(event.keyCode==13){$('#btnSearch').click();}" ></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                           <label class="pull-left">
                               From Date
                           </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                             TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <asp:DropDownList ID="ddlPrint" Visible="false" runat="server"></asp:DropDownList>
                        <cc1:CalendarExtender ID="calFromdate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b></div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" 
                            TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate">
                        </cc1:CalendarExtender>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-5" style="display:none;">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color: #90EE90;"  class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Photo&nbsp;Uploaded</b>
                </div>
                        
                        <div class="col-md-5" ></div>
                        <div class="col-md-10" style="text-align:center"><asp:Button ID="btnSearch" ClientIDMode="Static" runat="server" Text="Search" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" /></div>
                        <div class="col-md-8"></div>
                    </div>
                </div></div>
        </div> 
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:GridView ID="grdCard" runat="server" AutoGenerateColumns="false" Width="100%" OnRowCommand="grdCard_RowCommand" OnRowDataBound="grdCard_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UHID">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                        <ItemTemplate>
                            <asp:Label ID="lblPatientID" runat="server" ClientIDMode="Static" Text='<%#Eval("PatientID") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Patient Name">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="480px" />
                        <ItemTemplate>
                            <asp:Label ID="lblPName" runat="server" Text='<%#Eval("Pname") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Contact No.">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                        <ItemTemplate>
                            <asp:Label ID="lblContactNo" runat="server" Text='<%#Eval("Mobile") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Address" Visible="false">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                        <ItemTemplate>
                            <asp:Label ID="lblHouse_No" runat="server" Text='<%#Eval("House_No") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Sex">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                        <ItemTemplate>
                            <asp:Label ID="lblGender" runat="server" Text='<%#Eval("Gender") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Date Of Birth">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                        <ItemTemplate>
                            <asp:Label ID="lblDOB" runat="server" Text='<%#Eval("DOB1") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date Registration">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="160px" />
                        <ItemTemplate>
                            <asp:Label ID="lblDateEnrolled" runat="server" Text='<%#Eval("DateEnrolled") %>'></asp:Label>
                              <asp:Label ID="lblUploadPhoto" runat="server" Text='<%#Eval("PhotoUpload") %>' Visible="false"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                      <asp:TemplateField HeaderText="Photo" Visible="false">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbUpload" runat="server" CausesValidation="false" CommandName="imbUpload"
                                CommandArgument='<%# Eval("PatientID")+"#"+Eval("DateEnrolled") %>' ImageUrl="~/Images/login.png" />

                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Photo Browse" Visible="false">
                        <ItemTemplate>
                            <asp:FileUpload ID="FileUpload" runat="server" Width="200px"  />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        <ItemStyle CssClass="GridViewItemStyle"  />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Upload Photo" Visible="false">
                        <ItemTemplate>
                              <asp:ImageButton ID="imbUploadDirect" runat="server" CausesValidation="false" CommandName="imbUploadPhoto"
                                CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/Post.gif" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="View Photo" Visible="false">
                        <ItemTemplate>
                              <asp:ImageButton ID="imbViewPhoto" runat="server" 
                                 ImageUrl= "~/Images/view.GIF" CommandName="ViewPhoto" CommandArgument='<%#Container.DataItemIndex%>' />
                           
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Print Card" Visible="true">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="imbPrint" Visible="true"
                                CommandArgument='<%# Eval("PatientID") %>' ImageUrl="~/Images/print.gif" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="150px" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Print Sticker" Visible="false">
                        <ItemTemplate>
                         <%--<asp:ImageButton ID="imbPrintSticker" runat="server" CausesValidation="false" CommandName="imbPrintSticker"
                                CommandArgument='<%# Eval("PatientID") %>' ImageUrl="~/Images/print.gif" />--%>
                           <img id="imgPrintSticker" src="../../Images/print.gif" alt="Print" style="cursor: pointer" onclick="PrintSticker(this);" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                      <asp:TemplateField HeaderText="Print Lab Request Form" Visible="false">
                        <ItemTemplate>
                         <%--<asp:ImageButton ID="imbPrintSticker" runat="server" CausesValidation="false" CommandName="imbPrintSticker"
                                CommandArgument='<%# Eval("PatientID") %>' ImageUrl="~/Images/print.gif" />--%>
                           <img id="imgPrintSticker" src="../../Images/print.gif" alt="Print" style="cursor: pointer" onclick="labconcent(this);" />
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
     <asp:Panel ID="Panel1" runat="server" CssClass="pnlItemsFilter" Width="300px" Height="200px" style="display:none">
            <div id="Div1" runat="server" class="Purchaseheader">
                <b>Photo</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <em ><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closePatientDetail()"/> to close</span></em>
            </div>
            <div style="text-align: center;">
                <table style="width:300px; border-collapse:collapse; height: 162px;">
                    <tr>
                        <td style="text-align:center">
                            <img id="imgPatient" runat="server" src="~/Images/MaleDefault.png" style="height:161px;width:245px" alt="Patient Photo"/>
                        </td>
                    </tr>
                </table></div></asp:Panel>
      <cc1:ModalPopupExtender ID="mpe" TargetControlID="btn1" DropShadow="true" BackgroundCssClass="filterPupupBackground"
            PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel" runat="server"
            PopupControlID="Panel1" X="100" Y="90" BehaviorID="mpe">
        </cc1:ModalPopupExtender>
     <div style="display: none;">
            <asp:Button runat="server" ID="btn1" />
         <asp:Button  runat="server" ID="btnCancel"/>
     </div>
    

    
</asp:Content>
