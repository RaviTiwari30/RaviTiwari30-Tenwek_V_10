<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary_PostMortemResult.aspx.cs" Inherits="Design_Mortuary_Mortuary_PostMortemResult" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   
     <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
     <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
     <link href="../../Styles/framestyle.css" rel="stylesheet" />
      <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
      <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <script type="text/javascript" src="../../Scripts/Common.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            PostmortemStatus();
            $("#btnSave").click(function () {
                $("#lblErrorMsg").text("");
                if ($.trim($("#txtResult").val()) == "") {
                    $("#lblErrorMsg").text("Please Enter Postmortem Result");
                    $("#txtResult").focus();
                    return;
                }
                SavePostmortemResult();
            });
            $('#btncancel').click(function () {
                $("#btnSave").val("Save");
                $("#btnSave").attr("disabled", true);
                $('#btncancel').css('display', 'none');
                $("#btnedt").attr("disabled", false);
                $("#txtResult").val('');
                $('[id$=fufile]').val('');
                $('#chkfile').prop('checked', false);
            });
        });
    </script>
    <script type="text/javascript">
        var FilePath = "";
        function check(sender, e) {
            var keynum
            var keychar
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            //List of special characters you want to restrict

            if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
                return false;
            }
            else {
                return true;
            }
        }

        function PostmortemStatus() {
            $.ajax({
                url: "Services/Mortuary.asmx/PostmortemStatus",
                data: '{TransactionID:"' + $("#lblTransactionID").text() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "0") {
                        var Status = $.parseJSON(result.d);
                        if (Status[0]["IsPostmortem"] == "0") {
                            $("#lblErrorMsg").text("Before Postmortem You Can Not Enter Result");
                            $("#txtResult,#btnSave").attr("disabled", true);
                        }
                        else {
                            GetPostmortemResult();
                        }
                    }
                    else {
                        $("#lblErrorMsg").text("No Post-Mortem Request for The Corpse");
                        $("#txtResult,#btnSave").attr("disabled", true);
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function GetPostmortemResult() {
            $.ajax({
                url: "Services/Mortuary.asmx/GetPostmortemResult",
                data: '{TransactionID:"' + $("#lblTransactionID").text() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d != "0") {
                        CorpseResult = $.parseJSON(result.d);
                        var HtmlOutput = $("#SearchResult").parseTemplate(CorpseResult);
                        $("#divSearchedResult").html(HtmlOutput);
                        $("#divSearchedResult").show();
                        //$("#txtResult").val(result.d);
                        $("#btnSave").attr("disabled", true);
                    } else {
                        $("#divSearchedResult").empty();
                        $("#divSearchedResult").hide();
                        $("#btnSave").attr("disabled", false);
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function SavePostmortemResult() {
            var File = true;
            if ($('#chkfile').prop('checked') == true) {
                File = FileUpload();
            }
            if (File == false) {
                return false;
            }
            else {
                SaveResult();
            }
        }
        function SaveResult() {
            var Path = "";
            if (FilePath != null && FilePath != "") {
                var Path = FilePath;
            }
            debugger
            var FilePTH = new Array();
            FilePTH.push(Path);
            
            $("#btnSave").attr("disabled", true);
            $("#btnSave").val("Submitting...");
            var TransactionID = $("#lblTransactionID").text();
            var Result = $.trim($("#txtResult").val());
            
            $.ajax({
                url: "Services/Mortuary.asmx/SavePostMortemResult",
                data: JSON.stringify({ TransactionID: TransactionID, Result: Result, FilePTH: FilePTH }),//'{TransactionID:"' + TransactionID + '",Result:"' + Result + '",PathFile:"' + PathFile + '"}', //,Path:"' + Path + '"
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d != "0") {
                        $("#btnSave").attr("disabled", false);
                        $("#btnSave").val("Save");
                        DisplayMsg('MM01', 'lblErrorMsg');
                        modelAlert('Record Saved Successfully.', function () {
                            GetPostmortemResult();
                        })
                        
                        $("#txtResult").val('');
                        $('#btncancel').css('display', 'none');
                    }
                    else {
                        $("#btnSave").attr("disabled", false);
                        $("#btnSave").val("Save");
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                },
                error: function (xhr, status) {
                    $("#btnSave").attr("disabled", false);
                    $("#btnSave").val("Save");
                    DisplayMsg('MM05', 'lblErrorMsg');
                }
            });
        }
        function Edit(ctr) {
            $("#btnedt").attr("disabled", true);
            var CorpseId = $(ctr).closest("tr").find("#tdCorpseId").text();
            var Result = $(ctr).closest("tr").find("#tdResult").text();
            $("#txtResult").val(Result);
            $("#btnSave").val("Update");
            $("#btnSave").attr("disabled", false);
            $('#btncancel').css('display', 'block');
        }
        function View(ctr) {
        }
        function FileUpload() {
            if ($('#fufile').val() == '') {
                modelAlert('Please Select File');
                return false;
            }
            var fileUpload = $("#fufile").get(0);
            var files = fileUpload.files;
            var data = new FormData();
            for (var i = 0; i < files.length; i++) {
                data.append(files[i].name, files[i]);
            }
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: '../common/FileUploadHandler.ashx',
                data: data,
                contentType: false,
                processData: false,
                async: false,
                success: function (result) {
                    FilePath = result;
                    // modelAlert('Document Upload Successfully');
                    $('[id$=fufile]').val('');
                    $('#chkfile').prop('checked', false);
                    return false;
                },
                error: function (err) {
                    modelAlert(err.statusText)
                }
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Post-Mortem Result Entry</b>
                <br />
                <asp:Label ID="lblErrorMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Post-Mortem Result
                </div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 25%; text-align: right;">Post-Mortem Entry&nbsp;:&nbsp;</td>
                        <td style="width: 50%; text-align: left;">
                            <textarea id="txtResult" style="width: 500px; height: 157px; resize: none;" onkeypress="return check(this,event)"></textarea>
                        </td>
                        <td style="width: 25%; text-align: left;">
                            <span class="ItDoseLblError">*</span>
                        </td>
                    </tr>
                    <tr>
                         <td style="width: 25%; text-align: right;">Document Upload&nbsp;:&nbsp;</td>
                         <td style="width: 50%; text-align: left;">
                            <input type="checkbox" id="chkfile" />&nbsp;<input type="file" id="fufile" />
                         </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="">
                 <div class="row">
                 <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-12">
                        </div>
                         <div class="col-md-2">
                              <input type="button" id="btnSave" class="ItDoseButton" value="Save" />
                        </div>
                         <div class="col-md-2">
                              <input type="button" id="btncancel" style="display:none" class="ItDoseButton" value="Cancel" />
                        </div>
                         <div class="col-md-10">
                        </div>
                     </div>
                     </div>
                     </div>
            </div>
             <div class="POuter_Box_Inventory" style="">
                   <div id="divSearchedResult" style="width:100%;">
                   </div>
            </div>
        </div>
         <script type="text/html" id="SearchResult">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;">
		    <tr>       
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>     
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">CorpseID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Result</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Doctor Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Post-Mortem Date</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Post-Mortem Date</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Edit</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">View Doc.</th>	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {       

                var strStyle="";
		        objRow = CorpseResult[j];
                
		    #>
				    <tr style="<#=strStyle#>">            
                        <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                        <td class="GridViewLabItemStyle" id="tdCorpseId"  style="width:50px;text-align:center;" ><#=objRow.CorpseID#></td>
					    <td class="GridViewLabItemStyle" id="tdResult"  style="width:900px;text-align:center;" ><#=objRow.Result#></td>
                        <td class="GridViewLabItemStyle" id="tdDoctorName" style="width:200px;text-align:center; "><#=objRow.DoctorName#></td>    
					    <td class="GridViewLabItemStyle" id="tddate" style="width:200px;text-align:left; "><#=objRow.PostmortemDate#></td>
					    <td class="GridViewLabItemStyle" id="tdtime" style="width:200px;text-align:center;"><#=objRow.PostmortemTime#></td>
                         <td class="GridViewLabItemStyle" id="tdedt" style="width:200px;text-align:center;">
                             <input type="button" id="btnedt" value="Edit" class="" onclick="Edit(this)" />
                         </td>
                         <td class="GridViewLabItemStyle" id="tdView" style="width:200px;text-align:center;">
                         <a href="../../Documents/<#=objRow.File#>">    <img id="imgView" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="View(this);"/></a> 
                         </td>
                    </tr>             
                
		    <#}        
		    #> 
	    </table>    
        </script>
    </form>
    <asp:Label ID="lblTransactionID" runat="server" Style="display: none;" Text="jksdhgf" ClientIDMode="Static" />
    
</body>
</html>
