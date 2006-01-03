/*! \file xstream/z.h
 *
 * \brief C++ streambuf interface to read and write file formats supported by Zlib
 *
 */

#ifndef __XSTREAM_Z_H
#define __XSTREAM_Z_H

#include <xstream/config.h>

#if HAVE_LIBZ

#include <xstream/common.h>
#include <streambuf>

namespace xstream{
/*!
 * \brief zlib's compression/decompression (inflate/deflate) classes
 *
 */
namespace z{

// just a simple forward declaration so as to not include any zlib headers
struct pimpl;

/*!
 * \brief flush methods for deflate
 *
 */

enum flush_kind{
	no_sync,        /*!< flush the minimum possible data */
	normal_sync,    /*!< flushes all output possible so that decompressor can get the data written so far*/
	full_sync,      /*!< same as \c normal_sync but also writes "dictionary" data, so that even in case of corruption at a previous position , data can be decompressed from this point onward*/
	finish_sync,    /*!< write all data so that the stream can be closed*/
	block_sync      /*!< unknown */
};

/*!
 * \brief \e private class to factor some common code related with aquisition and release of zlib objects
 */
class common: public xstream::common_buffer
{
	protected:
		pimpl* z_strm; /*!< zlib stream "object" */

		/*!
		 *	\brief grows the output buffer
		 *
		 *	\param factor increase the size of buffer by factor times
		 *
		 * takes care of copying the valid data in the old buffer and freeing it
		 * as well of updating zlibs stream object to use the new buffers
		 *	
		 * */
		void grow_out(const unsigned int factor=2);

		/*!
		 * \brief construct using a streambuf
		 */
		common(std::streambuf* sb);

	public:
		/*!
		 * \brief number of bytes of output so far
		 *
		 */
		unsigned long int output_count() const;

		/*!
		 * \brief number of bytes of input so far
		 *
		 */
		unsigned long int input_count() const;

		/*!
		 * \brief checksum of uncompressed data so far
		 *
		 * on gzip streams the checksum is a crc32, otherwise the method is adler32
		 *
		 */
		unsigned long int checksum() const;

		/*!
		 * \brief dealocates the zlib stream
		 *
		 */
		~common();
};


/*!
 * \brief ouput Zlib stream class
 *
 * Just a thin wrapper for streambuf to deflate (compress) data
 * doesn't use zlib's fstream like interface, so no unnecessary buffer layer added
 * doesn't write gzip streams (yet)
 *
 */
class ostreambuf: public common, public xstream::ostreambuf {
	private:
		int level; /*!< compression level */

		/*!
		 * \brief inspect zlib error status and raise exception in case of error
		 *
		 */
		void raise_error(const int err);

		void init(void);

		/*!
		 * \brief flush as much data as possible (overloaded from streambuf)
		 *
		 * */
		int sync();

		/*!
		 * \brief write a character that surpasses buffer end (overloaded from streambuf)
		 * 
		 */
		int overflow(const int c);

		/*!
		 * \brief write an entire buffer (overloaded from streambuf)
		 *
		 */
		std::streamsize xsputn(char *buffer, std::streamsize n);
		
		/*!
		 * \brief fine tuned flushing of stream
		 *
		 * \param f kind of flush to do see flush_kind
		 *
		 */
		int flush(const flush_kind f);

	public:
		/*!
		 * \brief construct using a streambuf
		 */
		ostreambuf(std::streambuf* sb);

		/*! \brief construct specifying the compression level
		 *
		 * \param sb streambuf to use
		 * \param level 
		 *
		 * \note level should be between 1(worst compression) and 9 (best compression)
		 */
		ostreambuf(std::streambuf* sb, const int level);

		/*!
		 * \brief closes the zlib stream
		 *
		 */
		~ostreambuf();

};

/*!
 * \brief input Zlib stream class
 *
 * Just a thin wrapper for streambuf to inflate previously deflated data
 * doesn't use zlib's fstream like interface, so no unnecessary buffer layer added
 *
 */

class istreambuf: public common, public std::streambuf{
	private:

		/*!
		 * \brief inspect zlib error status and raise exception in case of error
		 *
		 */
		void raise_error(const int err);

		
		bool end; /*!<signals if stream has reached the end */

		/*!
		 * \brief requests that input buffer be reloaded (overloaded from streambuf)
		 *
		 */
		int underflow();

		/*!
		 * \brief encapsulates call to inflate and does error handling
		 * 
		 */
		void inflate(const flush_kind f = normal_sync );

		/*!
		 * \brief reads data and inflates it
		 */
		void read_inflate(const flush_kind f = normal_sync );

		/*!
		 * \brief reads \c n characters to \c buffer (overloaded from streambuf)
		 *
		 */
		std::streamsize xsgetn(char *buffer, std::streamsize n);

	public:
		/*!
		 * \brief construct using a streambuf
		 */
		istreambuf(std::streambuf* sb);

		/*!
		 * \brief closes the zlib stream
		 *
		 */
		~istreambuf();
};


}//namespace z
}//namespace xstream

/*!
 * \example z_decompress.cpp
 *
 * shows how to use the xstream::z::istreambuf to decompress an ordinary istream with data compressed in zlib or gzip format
 *
 * it can decompress from standard input to standard output or from file to file
 *
 */

/*!
 * \example z_compress.cpp
 *
 * shows how to use the xstream::z::ostreambuf to compress data into zlib format
 *
 * it can decompress from standard input to standard output or from file to file
 *
 */


#endif //have zlib

#endif
