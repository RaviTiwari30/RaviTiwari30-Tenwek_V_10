<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IssueVehicle.aspx.cs" Inherits="Design_Transport_IssueVehicle" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

 <script type="text/javascript">

        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
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
        function checkNumericDecimal(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            //if (sender.value == "1") {
            //    sender.value = sender.value.substring(0, sender.value.length - 1);
            //}


        }
        function isNumber(evt, element) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if ((charCode != 190 || $(element).val().indexOf('.') != -1)  // “.” CHECK DOT, AND ONLY ONE.
                    && (charCode != 110 || $(element).val().indexOf('.') != -1)  // “.” CHECK DOT, AND ONLY ONE.
                    && ((charCode < 48 && charCode != 8)
                            || (charCode > 57 && charCode < 96)
                            || charCode > 105))
                return false;
            return true;
        }

        $(document).ready(function () {
            $('#divFRow').hide();

            $('#rblRequisitionFrom').change(function () {
                SearchCriteria();
            });

            $('#ddlIssueDriver').change(function () {
                $('#txtIssueDriverContact1').val($('#ddlIssueDriver').val().split('#')[1]);
                $('#txtIssueDriverContact2').val($('#ddlIssueDriver').val().split('#')[2]);
                if ($('#txtIssueDriverContact1').val().length < 10) {
                    $('#txtIssueDriverContact1').removeAttr('disabled', 'false');
                }
                else {
                    $('#txtIssueDriverContact1').attr('disabled', 'disabled');
                }
                if ($('#txtIssueDriverContact2').val().length < 10) {

                    $('#txtIssueDriverContact2').removeAttr('disabled', 'false');
                }
                else {
                    $('#txtIssueDriverContact2').attr('disabled', 'disabled');
                }

            });

            $("#btnSearch").bind("click", SearchCriteria());

        });

        $ShowAckModel = function () {

            $('#divAckModel').showModel();
        }

        function SearchCriteria() {
            if ($('#rblRequisitionFrom').find(":checked").val() == "0") {
                $('#SpnMRNo,#txtMRNo,#SpnMRDot,#SpnPatientName,#SpnPNameDot,#txtPatientName,#divFRow').show();

                $('#SpnDepartment,#ddlFromDept,#SpnDeptDot').hide();
            }
            else if ($('#rblRequisitionFrom').find(":checked").val() == "1") {
                $('#SpnMRNo,#txtMRNo,#SpnMRDot,#SpnPatientName,#SpnPNameDot,#txtPatientName').hide();
                $('#SpnDepartment,#ddlFromDept,#SpnDeptDot,#divFRow').show();
            }
            else {
                $('#SpnMRNo,#txtMRNo,#SpnMRDot,#SpnPatientName,#SpnPNameDot,#txtPatientName,#SpnDepartment,#ddlFromDept,#SpnDeptDot,#divFRow').hide();
            }
        }

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
                        $("#spnErrorMsg").text('To date can not be less than from date!');
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
    <script type="text/javascript">
        $(document).ready(function () {
        
            $('.numbersOnly').keyup(function () {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });
            AckVehicle();              
        });     

        function AckVehicle() {
            $("#vehicle_div").empty();
            var Requests = Array();
            var Status = Array();
            $.ajax({
                url: "Services/Transport.asmx/AckVehicle",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d != null && mydata.d != "0") {
                        VehicleStatus = $.parseJSON(mydata.d);
                        if (VehicleStatus.length > 0) {
                            var HtmlOutput = $("#statusScript").parseTemplate(VehicleStatus);
                            $("#vehicle_div").html(HtmlOutput);
                            $("#vehicle_div").show();
                            Status = VehicleStatus;
                        }
                        else {
                            $("#vehicle_div").hide();
                        }
                    }
                    else {
                        $("#vehicle_div").empty();
                        $("#vehicle_div").hide();
                    }
                },
                error: function (xhr, status) {
                    $("#vehicle_div").empty();
                    $("#vehicle_div").hide();
                }
            });

        }

        function AckToken(rowID) {

            var BilledAmt = $(rowID).closest('tr').find('#tdBilledAmount').text();
            if (BilledAmt == null || BilledAmt == '' || BilledAmt=="") {
             
                $("#spnErrorMsg").text('Check Billed Amount..');
                return false;
            } else {
                $("#spnErrorMsg").text('');
            }

            $.ajax({                 
                url: "Services/Transport.asmx/AckToken",
                data: '{TokenNo:"' + $(rowID).closest('tr').find('#tdTokenNo').text() + '",MeterReading:"' + $(rowID).closest('tr').find('#txtMeterReading').val() + '",LastReading:"' + $(rowID).closest('tr').find('#tdLastReading').text() + '",KmRun:"' + $(rowID).closest('tr').find('#txtKmRun').val() + '",BilledAmount:"' + $(rowID).closest('tr').find('#tdBilledAmount').text() + '",Rate:"' + $(rowID).closest('tr').find('#tdRatePerKm').text() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d != "0") {
                        $("#spnErrorMsg").text('Record Updated Successfully');                      
                        AckVehicle();
                        window.open('../common/Commonreport.aspx');
                    }
                    else {
                        $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    }
                },
                error: function (xhr, status) {
                    console.log(xhr.responseText)
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
           
        }

        function GetBilledPrice(rowID) {
            $.ajax({
                
                url: "Services/Transport.asmx/GetBilledPrice",
                data: '{ReadingTypeId:"' + $(rowID).closest('tr').find('#tdReadingTypeID').text() + '",VechicalId:"' + $(rowID).closest('tr').find('#tdVehicleID').text() + '",KmRun:"' + $(rowID).closest('tr').find('#txtKmRun').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    VehicleStatus = $.parseJSON(mydata.d);

                    if (VehicleStatus.status) {
                        $(rowID).closest('tr').find('#tdBilledAmount').text(VehicleStatus.BilledAmount);
                        $("#spnErrorMsg").text("");
                        var valLastReading = Number($(rowID).closest('tr').find('#tdLastReading').text());
                        var valKmRun = Number( $(rowID).closest('tr').find('#txtKmRun').val());
                        var ReadingType = $(rowID).closest('tr').find('#tdReadingTypeID').text();
                        var Rate = 0;
                        if (ReadingType=="1") {
                             Rate = Number(VehicleStatus.BilledAmount) / valKmRun;
                        } else if (ReadingType == "2") {
                            Rate = Number(VehicleStatus.BilledAmount)
                        }
                        
                        $(rowID).closest('tr').find('#tdRatePerKm').text(Rate);

                        $(rowID).closest('tr').find('#txtMeterReading').val(valLastReading + valKmRun);
                        
                    }
                    else {
                        $(rowID).closest('tr').find('#tdBilledAmount').text('');
                        $(rowID).closest('tr').find('#tdRatePerKm').text(0);

                        var valLastReading = Number($(rowID).closest('tr').find('#tdLastReading').text());
                        var valKmRun = Number($(rowID).closest('tr').find('#txtKmRun').val());
                        $(rowID).closest('tr').find('#txtMeterReading').val(valLastReading + valKmRun);

                        $("#spnErrorMsg").text(VehicleStatus.Message);
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }

        


        function validateIssue() {
            if ($('#ddlIssueVehicle').val() == "0") {
                $('#ddlIssueVehicle').focus();
                alert('Please Select Vehicle');
                return false;
            }
            if ($('#ddlIssueDriver').val() == "0") {
                $('#ddlIssueDriver').focus();
                alert('Please Select Driver');
                return false;
            }
            if ($('#txtIssueDriverContact1').val() != '' && $('#txtIssueDriverContact1').val().length < 10) {
                $('#txtIssueDriverContact1').focus();
                alert('Enter a valid Contact Number');
                return false;

            }
            if ($('#txtIssueDriverContact2').val() != '' && $('#txtIssueDriverContact2').val().length < 10) {
                $('#txtIssueDriverContact2').focus();
                alert('Enter a valid Contact Number');
                return false;

            }
            if ($('#txtIssueDriverContact1').val() == '' && $('#txtIssueDriverContact2').val() == '') {
                alert('Please Enter At Least One Contact No of Driver')
                return false;
            }
            return true;

        }

    </script>

     <script type="text/html" id="statusScript">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;width:100%">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">VehicleNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">VehicleName</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">RcNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Model</th>			    	                				                                        	            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">VehicleType</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">LastReading</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">TokenNo</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:90px;">KM Run</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">MeterReading</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">ReadingType</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">BillingUser</th>
                	 <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Rate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Billed Amount</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Ack</th>
		    </tr>
		    <#       
		    var dataLength=VehicleStatus.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {
                objRow=VehicleStatus[j];
                                
		    #>
				    <tr>                                          
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:left;" id="tdVehicleNo" ><#=objRow.VehicleNo#></td>
                        <td class="GridViewLabItemStyle" style="width:200px;text-align:left;" id="tdVehicleName"><#=objRow.VehicleName#></td>    
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:left;" id="tdRcNo"><#=objRow.RcNo#></td> 
                        <td class="GridViewLabItemStyle" style="width:70px;text-align:left;" id="tdModel"><#=objRow.Model#></td>  
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdVehicleType"><#=objRow.VehicleType#></td>                           
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdLastReading"><#=objRow.LastReading#></td> 
                        <td class="GridViewLabItemStyle" style="width:150px;text-align:left;" id="tdTokenNo"><#=objRow.TokenNo#></td> 
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdkmRun">
                            <input type="text" id="txtKmRun" maxlength="6" style="width:70px" class="ItDoseTextinputNum" value='<#=objRow.KmRun#>' onkeypress="return isNumber(event,this);" onkeyup="GetBilledPrice(this)" onblur="GetBilledPrice(this)" onchange="GetBilledPrice(this)" />
                            
                          </td>
                          <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdMeterReading">
                             <input type="text" id="txtMeterReading" maxlength="6" style="width:70px" class="ItDoseTextinputNum" value='<#=objRow.MeterReading#>' onkeypress="return checkNumericDecimal(event,this);" />
                            
                            </td> 
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdReadingType"><#=objRow.ReadingType#></td> 

                        
                         <td class="GridViewLabItemStyle" style="width:90px;text-align:left;display:none" id="tdReadingTypeID"><#=objRow.ReadingTypeID#></td> 
                       <td class="GridViewLabItemStyle" style="width:90px;text-align:left;display:none" id="tdVehicleID"><#=objRow.VehicleID#></td> 
                       
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdBillingUser"><#=objRow.BillingUser#></td>     
                      <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdRatePerKm">0</td> 
                        <td class="GridViewLabItemStyle" style="width:90px;text-align:left;" id="tdBilledAmount"><#=objRow.BilledAmount#></td>
                        
                          <td class="GridViewLabItemStyle" style="width:30px;text-align:left;"><img id="imgAckToken" alt="" src="../../Images/Post.gif" style="cursor:pointer"  onclick="AckToken(this)"  /></td>    
                        
                                       
                    </tr>            
                
		    <#}        
		    #>                   
	    </table>    
    </script>

    <div class="body_box_inventory">       
          <div style="height:40px;"></div>
         <div  style="text-align: center;">
            <b>Issue Vehicle</b><br />
              <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>                    
        </div>

        <div>
            <div class="Purchaseheader">
                Search Criteria
            </div>
            
                <div class="POuter_Box_Inventory">

                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        
                         <div class="col-md-3">                         
                        </div>
                        <div class="col-md-5">
                          
                        </div>
                        
                        <div class="col-md-8">                          
                             <asp:RadioButtonList ID="rblRequisitionFrom" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist" ClientIDMode="Static">
                                <asp:ListItem Text="From Patient" Value="0"></asp:ListItem>
                                <asp:ListItem Text="From Department" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Both" Value="2"  Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                         <div class="col-md-3">                           
                              <span id="SpnStatus" class="pull-left">Status</span>
                                                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:DropDownList ID="ddlStatus" runat="server" Width="155px" ClientIDMode="Static">
                                <asp:ListItem Text="All" Value="All"></asp:ListItem>
                                <asp:ListItem Text="Pending" Value="0" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Issued" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Expired" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Rejected" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <div class="row" id="divFRow" style="display:none;">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                     
                        <div class="col-md-3">                         
                                <span id="SpnDepartment" class="pull-left">Department</span>
                            <b class="pull-right"><span id="SpnDeptDot" class="pull-left">:</span></b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFromDept" runat="server" Width="155px" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        
                        <div class="col-md-3">                          
                             <span id="SpnMRNo" class="pull-left">UHID</span>
                            <b class="pull-right"> <span id="SpnMRDot">:</span></b>
                        </div>
                        <div class="col-md-5"><asp:TextBox ID="txtMRNo" runat="server" MaxLength="15" Width="150px" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">                           
                              <span id="SpnPatientName" class="pull-left">Patient Name</span>
                                                       
                            <b class="pull-right"><span id="SpnPNameDot">:</span>  </b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server" Width="150px" MaxLength="20" ClientIDMode="Static"></asp:TextBox>
                           
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                     
                        <div class="col-md-3">                         
                            <span id="SpnFromDate" class="pull-left">From Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" Width="150px" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="clFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>
                        
                        <div class="col-md-3">                          
                             <span id="SpnToDate" class="pull-left">To Date</span>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"><asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" Width="150px" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>


                        <div class="col-md-3">                           
                            <span id="SpnTokenNo" class="pull-left">Token No.</span>                       
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                            
                            <asp:TextBox ID="txtTokenNo" runat="server" MaxLength="10" Width="150px"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            </div>
            <div class="POuter_Box_Inventory" align="center" >
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnSearch_Click" />&nbsp; <img alt="" src="../../Images/view.gif" style="cursor:pointer"  onclick="$ShowAckModel()"  /><strong>Acknowledge Vehicle</strong>
            </div>
            <div class="POuter_Box_Inventory" align="center">               
                 <div class="row">
                        <div style="text-align:center" class="col-md-6">
                            <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-warning"></button>
                             <b style="margin-top:5px;margin-left:5px;float:left">Pending</b> 
                        </div>
                         <div style="text-align:center" class="col-md-6">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-avilable"></button>
                             <b style="margin-top:5px;margin-left:5px;float:left">Issued</b> 
                        </div>
                         <div style="text-align:center" class="col-md-6">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-primary"></button>
                             <b style="margin-top:5px;margin-left:5px;float:left">Rejected</b> 
                        </div>
                         <div style="text-align:center" class="col-md-6">
                             <button type="button" style="width:25px;height:25px;margin-left:5px;float:left" class="circle badge-grey"></button>
                             <b style="margin-top:5px;margin-left:5px;float:left">Expired</b> 
                        </div>
             </div>


            </div>
        </div>
        <div class="POuter_Box_Inventory" id="showResults" runat="server" visible="false" clientidmode="Static">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div style="height: 150px; overflow: scroll">
                <asp:GridView ID="gvResult" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Width="100%" OnRowDataBound="gvResult_RowDataBound" OnRowCommand="gvResult_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="20px">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                                <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="TokenNo" HeaderText="Token No." HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField DataField="BookingDate" HeaderText="Booking Date" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField DataField="TYPE" HeaderText="Department" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField DataField="DestinationAddress" HeaderText="Destination Address" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                        <asp:BoundField DataField="CreatedBy" HeaderText="Created By" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                         <asp:BoundField DataField="Comment" HeaderText="Comment" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                      
                        
                         <asp:TemplateField HeaderText="Select" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnSelect" runat="server" ImageUrl="~/Images/Post.gif" CommandArgument='<%#Eval("TokenNo") %>' CommandName="Select" Visible='<%# Util.GetBoolean(Eval("chkStatus"))%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                            <ItemTemplate>
                              <%--  <asp:ImageButton ID="btnReject" runat="server" ImageUrl="~/Images/Delete.gif" Visible='<%# Util.GetBoolean(Eval("chkReject"))%>' CommandArgument='<%#Eval("TokenNo") %>' CommandName="Reject" />--%>
                                  <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Delete.gif" Visible='<%# Util.GetBoolean(Eval("chkReject"))%>'  CommandArgument='<%#Eval("TokenNo")+"#"+Eval("Status") %>' CommandName="Reject" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnPrint" runat="server" ImageUrl="~/Images/print.gif" Visible='<%# Util.GetBoolean(Eval("chkIssued"))%>' CommandArgument='<%#Eval("TokenNo") %>' CommandName="Print" />
                            </ItemTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Ack Print" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="btnAckPrint" runat="server" ImageUrl="~/Images/print.gif" Visible='<%# Util.GetBoolean(Eval("CanAckPrint"))%>' CommandArgument='<%#Eval("TokenNo") %>' CommandName="AckPrint" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="issueVehicle" runat="server" visible="false" clientidmode="Static">
            <div class="Purchaseheader">
                Issue Vehicle
            </div>
            <table align="center" width="100%">
                <tr>
                    <td align="right" width="20%">Token No. :
                    </td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssueTokenNo" runat="server" CssClass="ItDoseLabel"></asp:Label>
                    </td>
                    <td align="right" width="10%">Meater Reading Type</td>
                    <td align="left" width="20%">
                        <asp:RadioButtonList runat="server" ID="rblMeaterReadingType" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Text="Km Basis"></asp:ListItem>
                            <asp:ListItem  Value="2" Text="Range Basis"></asp:ListItem>
                        </asp:RadioButtonList>

                    </td>
                </tr>
                <tr id="tr_issuePatient1" runat="server">
                    <td align="right" width="20%">UHID :
                    </td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssueMRNo" runat="server"></asp:Label>
                    </td>
                    <td align="right" width="10%">Patient Name :
                    </td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssuePatientName" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr id="tr_issuePatient2" runat="server">
                    <td align="right" width="20%">Age/Sex :
                    </td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssueAgeSex" runat="server"></asp:Label>
                    </td>
                    <td align="right" width="10%">Mobile No. :
                    </td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssuePatientMobile" runat="server"></asp:Label>
                    </td>
                </tr>
                 <tr id="tr_issuePatient3" runat="server">
                    <td align="right" width="20%">Destination :</td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssueAddress" runat="server"></asp:Label></td>
                    <td align="right" width="10%">&nbsp;</td>
                    <td align="left" width="20%">&nbsp;</td>
                </tr>

                <tr id="tr_issueDepartment" runat="server">
                    <td align="right" width="20%">From Department :</td>
                    <td align="left" width="20%">
                        <asp:Label ID="lblIssueFromDepartment" runat="server"></asp:Label></td>
                    <td align="right" width="10%">&nbsp;</td>
                    <td align="left" width="20%">&nbsp;</td>
                </tr>

                <tr>
                    <td align="right" width="20%">Vehicle :
                    </td>
                    <td align="left" width="20%">
                        <asp:DropDownList ID="ddlIssueVehicle" runat="server" ClientIDMode="Static" Width="155px" OnSelectedIndexChanged="ddlIssueVehicle_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        <span style="color:red;">*</span>
                    </td>
                    <td align="right" width="10%">Driver :</td>
                    <td align="left" width="20%">
                        <asp:DropDownList ID="ddlIssueDriver" runat="server" ClientIDMode="Static" Width="155px"></asp:DropDownList>
                        <span style="color:red;">*</span>

                    </td>
                </tr>
                <tr>
                    <td align="right" width="20%">Driver Contact 1 :
                    </td>
                    <td align="left" width="20%">
                        <asp:TextBox ID="txtIssueDriverContact1" runat="server" Width="150px" ClientIDMode="Static" MaxLength="10" CssClass="numbersOnly"></asp:TextBox>
                    </td>
                    <td align="right" width="10%">Driver Contact 2 :
                    </td>
                    <td align="left" width="20%">
                        <asp:TextBox ID="txtIssueDriverContact2" runat="server" Width="150px" ClientIDMode="Static" MaxLength="10"  CssClass="numbersOnly"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="center" width="100%" colspan="4">
                        <asp:Button ID="btnIssue" runat="server" Text="Issue Vehicle" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnIssue_Click" OnClientClick="return validateIssue();" />
                    </td>

                </tr>
            </table>

        </div>
    
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
    </div>
    <cc1:ModalPopupExtender ID="mpReject" runat="server" CancelControlID="btnCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" PopupDragHandleControlID="Div1">
       </cc1:ModalPopupExtender>
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none">
        <div class="Purchaseheader" id="Div1" runat="server">
            Reject Requisition
        </div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 476px">
                <tr>
                    <td style="width: 101px;text-align:right;">Token No. :
                    </td>
                    <td style="width: 395px;text-align:left;">
                        <asp:Label ID="lblRejectTokenNo" runat="server" CssClass="ItDoseLabelSp" />
                        
                        <asp:HiddenField ID="hdrejectionSatus" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 101px;text-align:right;">Reason :
                    </td>
                    <td style="width: 395px;text-align:left;">
                        <asp:TextBox ID="txtRejectReason" runat="server" Width="250px"
                            ValidationGroup="RequsitionReject" MaxLength="100" />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                        <cc1:FilteredTextBoxExtender ID="cfsreason" TargetControlID="txtRejectReason" FilterType="LowercaseLetters,UppercaseLetters,Custom" ValidChars=" " runat="server"></cc1:FilteredTextBoxExtender>
                        <asp:RequiredFieldValidator ID="rq1" runat="server" ControlToValidate="txtRejectReason"
                            ErrorMessage="Specify Reject Reason" ValidationGroup="RequsitionReject" Text="*" Display="None" />
                    </td>
                </tr>
                 <tr>
                    <td style="width: 101px;text-align:right;">Approved By :
                    </td>
                    <td style="width: 395px;text-align:left;">
                        <!--This hardcoded acording to gGAURAV-->
                        <asp:DropDownList ID="ddlApprovedBy" runat="server"> 
                            <%-- <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">Hospital</asp:ListItem>--%>
                            
                        </asp:DropDownList>
                        <asp:CompareValidator ID="cvApproval" runat="server" ControlToValidate="ddlApprovedBy" ValidationGroup="RequsitionReject" Type="String" ValueToCompare="0" Operator="NotEqual" ErrorMessage="Please Select Approval" Text="*" Display="None"></asp:CompareValidator>
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnReject" runat="server" CssClass="ItDoseButton" Text="Reject"
                ValidationGroup="RequsitionReject" OnClick="btnReject_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="RequsitionReject" />
    

<div id="divAckModel"   class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:1200px;height:auto;">
                <div class="modal-header">
                    <h4 class="modal-title">Acknowledge Vehicle</h4>
                     <span id="spnErrorMsg" class="ItDoseLblError"></span>
                </div>
                <div class="modal-body">
                     <div class="row">
                         <div class="col-md-20">
                                <div id="vehicle_div" style="margin: 0 auto;width:1160px; height:180px; overflow:scroll;">
                            </div>
                          </div>
                       
                      </div>
                </div>
                  <div class="modal-footer">
                       
                         <button type="button"  data-dismiss="divAckModel" >Close</button>
                </div>
            </div>
        </div>
    </div>



  
</div>
</asp:Content>

