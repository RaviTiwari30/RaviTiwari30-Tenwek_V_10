<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DiscountReport.aspx.cs" Inherits="NewReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%--<html>
        <head></head>
        <body>
            <div Id="main1" class="Pbody_box_inventory" style="margin-top:33px;background-color:white;width:90%">
                <div id="Hbox" class="row" style="padding-bottom:8px;border-bottom:1px solid;margin-left:0px;margin-right:0px;">

                    <div class="col-md-7"  id="FirstBox">Center:<select id="ddlCenter" style="width:200px;">
                        <option>Select</option>
                                                                </select></div>
                    <div class="col-md-4" id="SecondBox"><input type="radio" name="g" id="rbdOPD" />OPD</div>
                    <div class="col-md-4" id="ThirdBox"><input type="radio" name="g" id="rbdIPD" />IPD</div>
                    <div class="col-md-5" id="FourthBox"><input type="radio" name="g" id="rbdPharmacy" />PHARMACY</div>
                    <div class="col-md-4" id="FifthBox"><input type="radio" name="g" id="rbdAll" />All</div>
                </div>
                <div id="MBox" style="padding-top:10px">

                    <div id="MBox1" class="col-md-8">Apprval Type: <select style="width:200px"><option>Select</option></select></div>
                    <div id="MBo2"class="col-md-4">Discount Amount Range</div>
                    <div id="MBo3" class="col-md-4"><input type="checkbox" />  <input type="text" style="width:75%"/></div>
                    <div id="Div5" class="col-md-4">From Date : <input type="text" style="width:54%" /></div>
                    <div id="Div6" class="col-md-4">To Date : <input type="text" style="width:54%" /></div>

                </div>
                </div>
         

        </body>
    </html>--%>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Discount Report </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               Enter Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" checked="checked" name="g" id="rbdOpd" />OPD
                            <input type="radio"  name="g"  id="rbtIpd" />IPD
                            <input type="radio" name="g"  id="rbdPharmacy" />Pharmacy
                            <input type="radio" name="g"  id="rbdAll" />All
                        </div>
                        <div class="col-md-3">
                            <label class="pull-right">
                               Dis Amt  From :
                            </label>
                        </div>
                        <div class="col-md-5">
                          <input type="text" id="txtMin" value="0" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-right">
                             To :
                            </label>
                        </div>
                        <div class="col-md-5">  
                          <input type="text" value="0" id="txtMax"  />
                          </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               Approval Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlApprovalType">
                               <option></option>
                           </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-right">
                                From Date :
                            </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-right">
                                   To Date :
                            </label>
                    </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                              <label class="pull-left">
                                  Report Type
                              </label>
                            <b class="pull-right">:</b>
                         </div>
                        <div class ="col-md-5">
                               <input type="radio" name="e" id="rbdExcel" value="Excel" />Excel
                              <input type="radio" id="rbdPDF" checked="checked" name="e" value="PDF" />PDF
                        </div>
                        <div class ="col-md-3"></div>
                        <div class ="col-md-5"></div>
                        <div class ="col-md-3"></div>
                        <div class ="col-md-5"></div>
                      </div>
                    <div class="row">
                        <div class="col-md-3">
                             <label class="pull-left">
                          <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" onclick="checkAllCentre();" runat="server"  />
                            Centre
                            </label>
                              <b class="pull-right">:</b>
                          </div>
                        <div class="col-md-12">
                                <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                                </asp:CheckBoxList>
                         </div>
                    </div>
                <%--<tr>
                    <td style="width: 20%; text-align: right; vertical-align: central; border: groove;">
                        <asp:CheckBox ID="chkAllItem" ClientIDMode="Static" CssClass="AllItem" runat="server" onclick="checkAllItem();" Text="All :&nbsp;" />

                    </td>
                    <td colspan="4" style="height: 150px; border: groove;">
                        <div style="height: 207px; width: 100%; text-align: left;" class="scrollankur">
                            <asp:CheckBoxList ID="chkItems" runat="server" CssClass="ItDoseCheckboxlist chkItem" RepeatColumns="6" ClientIDMode="Static"
                                RepeatDirection="Horizontal" RepeatLayout="Table" onclick="checkItem();">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>--%>
           </div>
            </div> 
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-12">
                    <asp:Button Style="display:none" ID="btnPreview" runat="server" Text="Report" 
                CssClass="ItDoseButton"  ToolTip="Click To Open report" TabIndex="4" />
                    <input type="button" class="ItDoseButton" ID="btnPreview1" style="float:right" value="Report" onclick="DiscountReport()" />
                    </div>
                 <div class="col-md-4">
                      </div>
                 <div class="col-md-4">
                    </div>
                </div>
        </div>
     </div>
    <script type="text/javascript">
        $(function () {
            checkAllCentre();
        });
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                 $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
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
                        $('#btnPreview').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnPreview').removeAttr('disabled');
                    }
                }
            });

        }

        $(document).ready(function () {
            FunctionForApprovalType();
           // DiscountReport();
        })

        function FunctionForApprovalType() {
            $.ajax({
                url: "DiscountReport.aspx/FunctionForApprovalType",
                type: "Post",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var item = jQuery.parseJSON(response.d);
                    for (var i = 0; i < item.length; i++) {
                        //$("#ddlApprovalType").append(("<option></option>").html(item[i].ApprovalType).val(item[i].id));
                        $("#ddlApprovalType").append($("<option></option>").val(item[i].id).html(item[i].ApprovalType));
                    }
                }
            })
        }

        function DiscountReport() {
            var CenterID = $("#chkCentre_0").val();
            var ApprovalType = $("#ddlApprovalType option:selected").text();
            var chkAllCentre = $("#chkAllCentre").val();
            var fromDate = $("#ucFromDate").val();
            var ToDate = $("#ucToDate").val();
            var minDis = $("#txtMin").val();
            var maxDis = $("#txtMax").val();
            var value = "";
            var GetType, MimDiscount = "";
           
            if ($("#rbdOpd").is(":checked")) {
                value = "OPD";
            }
            if ($("#rbtIpd").is(":checked")) {
                value = "IPD";
            }
            if ($("#rbdPharmacy").is(":checked")) {
                value = "Pharmacy";
            }
            if ($("#rbdAll").is(":checked")) {
                value = "All";
            }
      
            if ($("#rbdExcel").is(":checked")) {
               GetType = "Excel";
            }

            if ($("#rbdPDF").is(":checked")) {
                GetType = "Pdf";
            }
          
            
            if ($("#rbdAll").is(":checked"))
            {
                var MimDiscount = $("#txtMinDiscountAmount").text();
            }
            if ($("#rbdAll").is(":checked"))
            {
                var MixDiscount = $("#txtMaxDiscountAmount").text();
            }

           
            if (chkAllCentre == "") {
                $("#chkAllCentre").css('border-color', 'firebrick').focus();
                $("#chkAllCentre").keyup(function () {
                    $(this).css('border-color', '#dddddd');
                });
                return false;
            }
           
            var checkedCentreCount = $('#chkCentre input[type=checkbox]:checked').length;

            if (checkedCentreCount==0) {
                $('#<%=lblMsg.ClientID%>').text('Please Select Centre');
                return false;
            }
           
             var checkedCheckBox = $('#chkCentre input[type=checkbox]:checked');
            CenterID = '';
            for (var i = 0; i < checkedCheckBox.length; i++) {

                CenterID += checkedCheckBox[i].value;
                if (checkedCentreCount != i + 1)
                    CenterID += ","
            }
           


            $.ajax({
                url: "DiscountReport.aspx/DiscountReport",
                data: '{fromDate:"' + fromDate + '",toDate:"' + ToDate + '",ApprovalType:"' + ApprovalType + '",value:"' + value + '",CenterID:"' + CenterID + '",GetType:"' + GetType + '",minDis:"' + minDis + '",maxDis:"' + maxDis + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    debugger;
                    var item = jQuery.parseJSON(response.d);
                    if (item == "1") {
                        window.open('../../Design/common/Commonreport.aspx');
                        
                    
                    }
                    if (item == "2") {
                        window.open('../../Design/common/ExportToExcel.aspx');


                    }
                }
            })
        }
        

    </script>


</asp:Content>

